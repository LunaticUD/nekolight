# 1. 基础设置
# 开启变量替换，允许 PROMPT 解析变量
setopt prompt_subst

# 2. 初始化 git_info 关联数组 (这是 Basher 成功的关键)
typeset -gA git_info

# 3. 配置 Git 样式
# 只有当 git-info 函数存在时才运行 (即 .zimrc 中加载了 git 模块)
if (( ${+functions[git-info]} )); then
  
  # [重点逻辑]: 利用 Clean 和 Dirty 来控制颜色
  # 如果仓库是干净的，%C 会输出绿色代码
  zstyle ':zim:git-info:clean' format '%B%F{green}'
  
  # 如果仓库是脏的 (有修改)，%D 会输出红色代码
  zstyle ':zim:git-info:dirty' format '%B%F{red}'
  
  # 分支名本身只显示名字 (颜色由上面的 clean/dirty 控制)
  zstyle ':zim:git-info:branch' format '%b'

  # [核心格式]: 定义 prompt 键的格式
  # " on " + %C(绿)或%D(红) + 图标 + 分支名 + %f(重置颜色)
# 修改后 (正确)
  zstyle ':zim:git-info:keys' format \
         'prompt' ' on %C%D %b%f'

  # 注册钩子，在每次显示提示符前运行 git-info
  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

# 4. 定义 PROMPT
# 结构：
# 1. 蓝色路径: %B%F{blue}%~%f%b
# 2. Git信息:  ${(e)git_info[prompt]} (引用上面配置好的 git 字符串)
# 3. 换行
# 4. 状态箭头: %(? ... ) 成功绿，失败红
PROMPT='%B%F{blue}%~%f%b${(e)git_info[prompt]}
%(?,%B%F{green}❯%f%b,%B%F{red}❯%f%b) '
# # ------------------------------------------------------------------------------
# # Zimfw Theme: nekolight (Optimized for Zsh)
# # ------------------------------------------------------------------------------
#
# # 1. 开启变量替换
# setopt prompt_subst
#
# # 2. 配置 Zimfw Git 模块
# zstyle ':zim:git:info:branch' format '%b'
# zstyle ':zim:git:info:status' format '!'
#
# # 3. 使用钩子函数更新 Git 信息
# # 这样避免了在 PROMPT 中使用 $(...) 子进程
# function prompt_nekolight_precmd() {
#   # 显式触发 Zim 的 git 信息采集
#   if (( $+functions[git-info] )); then
#     git-info
#   fi
#
#   # 构建 Git 提示字符串
#   _PROMPT_GIT_INFO=""
#   if [[ -n ${zim_git_info_keys[branch]} ]]; then
#     local git_symbol=""
#     local git_color='%B%F{green}'
#     
#     # 判断是否 dirty
#     if [[ -n ${zim_git_info_keys[status]} ]]; then
#       git_color='%B%F{red}'
#     fi
#     
#     _PROMPT_GIT_INFO=" on ${git_color}${git_symbol} ${zim_git_info_keys[branch]}%f%b"
#   fi
# }
#
# # 注册钩子
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd prompt_nekolight_precmd
#
# # 4. 组装 PROMPT
# # 第一行：路径 + Git信息
# # 第二行：根据返回状态变色的箭头
# PROMPT='%B%F{blue}%~%f%b${_PROMPT_GIT_INFO}
# %(?,%B%F{green}❯%f%b,%B%F{red}❯%f%b) '
#
# # 可选：如果你喜欢原版 Bash 样式的右侧提示符，可以用 RPROMPT
# # RPROMPT=''
