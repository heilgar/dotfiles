local M = {}
local Job = require('plenary.job')
local uv = vim.loop

function M.search_json()
    -- Get the current buffer content
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local json_content = table.concat(lines, '\n')

    vim.schedule(function()
        vim.ui.input({
            prompt = "JMESPath query: ",
        }, function(query)
            if not query or query == '' then
                vim.notify('Query cannot be empty', vim.log.levels.WARN)
                return
            end

            local tmp_json = vim.fn.tempname()
            local fd, err = uv.fs_open(tmp_json, "w", 438) -- 438 in decimal is 0666 in octal
            if not fd then
                vim.notify('Failed to create temporary file: ' .. err, vim.log.levels.ERROR)
                return
            end

            -- Correct usage of uv.fs_write with offset
            local write_result, write_err = uv.fs_write(fd, json_content, 0)
            if not write_result then
                vim.notify('Failed to write to temporary file: ' .. write_err, vim.log.levels.ERROR)
                uv.fs_close(fd)
                uv.fs_unlink(tmp_json)
                return
            end

            uv.fs_close(fd)

            -- Debug: Print the content written to temp file
            print("JSON content written to temp file:", json_content)

            -- Store stdout lines
            local stdout_data = {}

            local job = Job:new({
                command = 'jp',
                args = { '-f', tmp_json, query }, -- Removed extra quotes around query
                on_stdout = function(_, data)
                    if data then
                        table.insert(stdout_data, data)
                        -- print("Received stdout line:", data)
                    end
                end,
                on_stderr = function(_, data)
                    if data and data ~= '' then
                        print("stderr: " .. vim.inspect(data))
                        vim.schedule(function()
                            vim.notify('JMESPath error: ' .. data, vim.log.levels.ERROR)
                        end)
                    end
                end,
                on_exit = function(j, return_val)
                    print("Job exit code:", return_val)
                    uv.fs_unlink(tmp_json)

                    if return_val == 0 then
                        -- Debug: Print all collected stdout
                        print("All stdout:", vim.inspect(stdout_data))

                        vim.schedule(function()
                            vim.cmd('tabnew')
                            local buf = vim.api.nvim_create_buf(true, true)
                            vim.api.nvim_win_set_buf(0, buf)

                            -- Use collected stdout_data instead of j:result()
                            local result = stdout_data
                            if #result == 0 then
                                result = { 'No results found' }
                            end

                            vim.api.nvim_buf_set_name(buf, 'JMESPath: ' .. query)
                            vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
                            vim.bo[buf].filetype = 'json'
                            vim.bo[buf].modifiable = true
                            vim.bo[buf].buftype = '' -- Make it a normal buffer so it can be saved

                            -- Add keybinding to save results
                            vim.keymap.set('n', '<leader>w', function()
                                local filename = vim.fn.input('Save results to file: ')
                                if filename and filename ~= '' then
                                    vim.cmd('write ' .. filename)
                                    vim.notify('Results saved to: ' .. filename, vim.log.levels.INFO)
                                end
                            end, { buffer = buf, desc = 'Save JMESPath results to file' })

                            -- Debug: Print buffer content
                            print("Buffer content:", vim.inspect(result))
                        end)
                    else
                        vim.schedule(function()
                            vim.notify('Command failed with exit code: ' .. return_val, vim.log.levels.ERROR)
                        end)
                    end
                end,
            })

            -- Debug: Print the command that will be executed
            print(string.format("Running command: jp -f %s %s", tmp_json, query))

            job:start()
            -- Removed job:wait() to avoid blocking the UI. Plenary.Job handles async execution.
        end)
    end)
end

return M

