return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require "dap"
			local ui = require "dapui"

			require("dapui").setup()
			require("dap-go").setup()
			dap.adapters.lldb = {
				type = 'executable',
				command = '/opt/homebrew/opt/llvm/bin/lldb-dap', -- adjust as needed, must be absolute path
				name = 'lldb'
			}
			dap.configurations.cpp = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					args = {},

					-- 💀
					-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
					--
					--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
					--
					-- Otherwise you might get the following error:
					--
					--    Error on launch: Failed to attach to the target process
					--
					-- But you should be aware of the implications:
					-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
					-- runInTerminal = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
			dap.configurations.rust = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					args = {},
					-- ... the previous config goes here ...,
					initCommands = function()
						-- Find out where to look for the pretty printer Python module
						local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

						local script_import = 'command script import "' ..
							rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
						local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

						local commands = {}
						local file = io.open(commands_file, 'r')
						if file then
							for line in file:lines() do
								table.insert(commands, line)
							end
							file:close()
						end
						table.insert(commands, 1, script_import)

						return commands
					end,
					-- ...,
				}
			}
			dap.configurations.java = {
				{
					name = "Debug Launch (2GB)",
					type = 'java',
					request = 'launch',
					vmArgs = "" ..
						"-Xmx2g "
				},
				{
					name = "Debug Attach (8000)",
					type = 'java',
					request = 'attach',
					hostName = "127.0.0.1",
					port = 8000,
				},
				{
					name = "Debug Attach (5005)",
					type = 'java',
					request = 'attach',
					hostName = "127.0.0.1",
					port = 5005,
				},
			}
			require("nvim-dap-virtual-text").setup {
				-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
				-- display_callback = function(variable)
				-- 	local name = string.lower(variable.name)
				-- 	local value = string.lower(variable.value)
				-- 	if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
				-- 		return "*****"
				-- 	end
				--
				-- 	if #variable.value > 15 then
				-- 		return " " .. string.sub(variable.value, 1, 15) .. "... "
				-- 	end
				--
				-- 	return " " .. variable.value
				-- end,
				--

			}

			-- Handled by nvim-dap-go
			-- dap.adapters.go = {
			--   type = "server",
			--   port = "${port}",
			--   executable = {
			--     command = "dlv",
			--     args = { "dap", "-l", "127.0.0.1:${port}" },
			--   },
			-- }

			local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
			if elixir_ls_debugger ~= "" then
				dap.adapters.mix_task = {
					type = "executable",
					command = elixir_ls_debugger,
				}

				dap.configurations.elixir = {
					{
						type = "mix_task",
						name = "phoenix server",
						task = "phx.server",
						request = "launch",
						projectDir = "${workspaceFolder}",
						exitAfterTaskReturns = false,
						debugAutoInterpretAllModules = false,
					},
				}
			end



			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F6>", dap.step_into)
			vim.keymap.set("n", "<F7>", dap.step_over)
			vim.keymap.set("n", "<F8>", dap.step_out)
			vim.keymap.set("n", "<F9>", dap.step_back)
			vim.keymap.set("n", "<F10>", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				-- ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				-- ui.close()
			end
		end,
	},
}
