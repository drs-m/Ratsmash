module ApplicationHelper

	def footer_head_info
		if true and @current_user.admin_permissions
			return "" unless File.exists?(Rails.root + "head_info_yml")
			head_info = YAML.load_file(Rails.root + "head_info.yml")
			return "" if head_info.blank?
			github_base_url = "http://github.com/Ratsmash-dev/RMash/commit/"
			html_blueprint = " <span id='git-version'>latest commit: <a href='%git_url%' target='_blank'>%sha%</a> - by: %user%</span>"
			html_response = html_blueprint.gsub("%git_url%", github_base_url + head_info[:sha])
			html_response = html_response.gsub("%sha%", head_info[:sha][0..5])
			html_response = html_response.gsub("%user%", head_info[:user_mail].split("@")[0])
			return html_response
		end
	end

end
