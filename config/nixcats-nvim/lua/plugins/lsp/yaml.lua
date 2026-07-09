local M = {}

local function detect_yaml_type(filepath, filename)
	local lc_path = filepath:lower()
	local lc_name = filename:lower()

	if lc_name:match("azure%-pipelines?%.ya?ml$") or lc_name:match("%.azure%-pipelines?%.ya?ml$") then
		return "azure-pipelines"
	end
	if lc_path:match("/%.?azure%-pipelines?/") or lc_path:match("/[^/]*pipelines?/") then
		return "azure-pipelines"
	end

	if lc_path:match("%.github/workflows/") then
		return "github-workflow"
	end

	if lc_name:match("docker%-compose") or lc_name:match("compose%.ya?ml$") then
		return "docker-compose"
	end

	if lc_name:match("^chart%.ya?ml$") then
		return "helm-chart"
	end

	if lc_name:match("values%.ya?ml$") or lc_path:match("/templates/") then
		return "helm"
	end

	if
		lc_path:match("/playbooks/")
		or lc_path:match("/roles/")
		or lc_path:match("/tasks/")
		or lc_path:match("/handlers/")
		or lc_path:match("/vars/")
		or lc_path:match("/defaults/")
		or lc_name:match("^site%.ya?ml$")
		or lc_name:match("^main%.ya?ml$")
		or lc_name:match("^playbook")
		or lc_name:match("inventory%.ya?ml$")
	then
		return "ansible"
	end

	local file = io.open(filepath, "r")
	if file then
		local content = file:read("*a")
		file:close()

		if
			content:match("apiVersion:")
			or content:match("kind:%s*Deployment")
			or content:match("kind:%s*Service")
			or content:match("kind:%s*ConfigMap")
			or content:match("kind:%s*Pod")
			or content:match("kind:%s*Ingress")
		then
			return "kubernetes"
		end
	end

	return "yaml"
end

---@param capabilities table LSP client capabilities (from cmp_nvim_lsp or similar).
function M.setup(capabilities)
	vim.lsp.config("yamlls", {
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml", "yaml.docker-compose", "yaml.ansible" },
		capabilities = capabilities,
		settings = {
			yaml = {
				schemaStore = {
					enable = true,
					url = "https://www.schemastore.org/api/json/catalog.json",
				},
				schemas = {
					["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
						"azure-pipelines.yml",
						"azure-pipelines.yaml",
						"*.azure-pipelines.yml",
						"*.azure-pipelines.yaml",
						".azure-pipeline*/**/*.yml",
						".azure-pipeline*/**/*.yaml",
						"azure-pipeline*/**/*.yml",
						"azure-pipeline*/**/*.yaml",
						"**/*pipelines/**/*.yml",
						"**/*pipelines/**/*.yaml",
					},
					["https://json.schemastore.org/github-workflow.json"] = {
						".github/workflows/*.yml",
						".github/workflows/*.yaml",
					},
					["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
						"docker-compose*.yml",
						"docker-compose*.yaml",
						"compose.yml",
						"compose.yaml",
						"*.docker-compose.yml",
						"*.docker-compose.yaml",
					},
					["https://json.schemastore.org/chart.json"] = { "Chart.yaml", "Chart.yml" },
					["https://json.schemastore.org/values.schema.json"] = { "values.yaml", "values.yml" },
					["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json"] = {
						"**/playbooks/*.yml",
						"**/playbooks/*.yaml",
						"**/roles/*.yml",
						"**/roles/*.yaml",
						"**/tasks/*.yml",
						"**/tasks/*.yaml",
						"**/handlers/*.yml",
						"**/handlers/*.yaml",
						"site.yml",
						"site.yaml",
						"main.yml",
						"main.yaml",
						"playbook*.yml",
						"playbook*.yaml",
					},
					["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json"] = {
						"*.k8s.yaml",
						"*.k8s.yml",
						"*.kubernetes.yaml",
						"*.kubernetes.yml",
					},
				},
				format = {
					enable = true,
					singleQuote = true,
					bracketSpacing = true,
					proseWrap = "preserve",
					printWidth = 120,
				},
				validate = true,
				completion = true,
				hover = true,
				customTags = { "!vault", "!encrypted/pkcs1-oaep scalar" },
			},
		},
	})

	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = { "*.yaml", "*.yml" },
		callback = function()
			local filepath = vim.fn.expand("%:p")
			local filename = vim.fn.expand("%:t")
			local yaml_type = detect_yaml_type(filepath, filename)

			if yaml_type == "docker-compose" then
				vim.bo.filetype = "yaml.docker-compose"
				print(" Docker Compose detected")
			elseif yaml_type == "ansible" then
				vim.bo.filetype = "yaml.ansible"
				print(" Ansible detected")
			elseif yaml_type == "helm-chart" then
				vim.bo.filetype = "yaml"
				print("⎈ Helm Chart.yaml detected")
			elseif yaml_type == "helm" then
				vim.bo.filetype = "helm"
				print("⎈ Helm detected")
			elseif yaml_type == "kubernetes" then
				vim.bo.filetype = "yaml"
				print("  Kubernetes detected")
			elseif yaml_type == "azure-pipelines" then
				vim.bo.filetype = "yaml"
				print(" Azure Pipelines detected")
			elseif yaml_type == "github-workflow" then
				vim.bo.filetype = "yaml"
				print(" GitHub Actions detected")
			else
				vim.bo.filetype = "yaml"
				print(" Generic YAML detected")
			end
		end,
	})

	vim.api.nvim_create_user_command("YamlSchema", function(opts)
		local schema_type = opts.args
		local schemas = {
			kubernetes = {
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json"] = {
					"*.yaml",
					"*.yml",
				},
			},
			ansible = {
				["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json"] = {
					"*.yaml",
					"*.yml",
				},
			},
			docker = {
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
					"*.yaml",
					"*.yml",
				},
			},
			azure = {
				["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
					"*.yaml",
					"*.yml",
				},
			},
			github = {
				["https://json.schemastore.org/github-workflow.json"] = { "*.yaml", "*.yml" },
			},
			helm = {
				["https://json.schemastore.org/chart.json"] = { "*.yaml", "*.yml" },
			},
		}

		if schemas[schema_type] then
			vim.lsp.buf_notify(0, "yaml/schema/store", {
				schemas = schemas[schema_type],
			})
			print("✓ YAML schema changed to: " .. schema_type)
			local clients = vim.lsp.get_clients({ bufnr = 0, name = "yamlls" })
			for _, client in ipairs(clients) do
				client.stop()
			end
			vim.defer_fn(function()
				vim.lsp.enable("yamlls")
			end, 200)
		else
			print(" Unknown schema. Available: kubernetes, ansible, docker, azure, github, helm")
		end
	end, {
		nargs = 1,
		complete = function()
			return { "kubernetes", "ansible", "docker", "azure", "github", "helm" }
		end,
		desc = "Change YAML schema for current buffer",
	})
	vim.keymap.set("n", "<leader>ys", ":YamlSchema ", { desc = "Change YAML schema" })
end

return M
