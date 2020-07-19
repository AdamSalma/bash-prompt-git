function custom_prompt()
  cwd = clink.get_cwd()
  prompt = "[\x1b[1;31;40m{time}\x1b[0m] \x1b[1;32;40m{cwd}\x1b[0m {git}{hg} \n{lamb} \x1b[0m"
  new_value = string.gsub(prompt, "{cwd}", cwd)
  add_time = string.gsub(new_value, "{time}", os.date("%H:%M"))
  clink.prompt.value = string.gsub(add_time, "{lamb}", "λ")
end

clink.prompt.register_filter(custom_prompt, 1)

