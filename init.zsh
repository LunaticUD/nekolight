# ------------------------------------------------------------------------------
# Zimfw Theme: nekolight
# Ported from oh-my-bash nekolight theme
# ------------------------------------------------------------------------------

# 1. 开启变量替换，允许在 PROMPT 中解析变量和函数
setopt prompt_subst

# 2. 配置 Zimfw 的 git 模块格式
# 我们需要让 git 模块只提供纯文本的分支名，不需要它自带颜色或括号
# 因为颜色逻辑由我们下面的函数控制
zstyle ':zim:git:info:branch' format '%b'

# 配置 status 格式。
# 我们不需要它显示具体的符号（如 M, ?），但必须设置它不为空，
# 这样 zim 才会去检测仓库是否 dirty，从而填充 status 变量供我们在函数中判断
zstyle ':zim:git:info:status' format '!'

# 3. 定义 Git 信息生成函数
# 逻辑：如果仓库是干净的 -> 绿色；如果有修改 -> 红色
function prompt_nekolight_git() {
  # 如果当前不在 git 仓库中 (branch key 为空)，则不显示任何内容
  [[ -z ${zim_git_info_keys[branch]} ]] && return

  local git_symbol=""
  local git_color='%B%F{green}' # 默认为绿色 (Bold + Green)

  # 检查 status key 是否有内容
  # 在 Zim 中，如果有文件被修改，zim_git_info_keys[status] 将不会为空
  if [[ -n ${zim_git_info_keys[status]} ]]; then
    git_color='%B%F{red}'        # 变为红色 (Bold + Red)
  fi

  # 对应 Bash 中的逻辑: "on " + Color + Symbol + Branch
  # 注意：Bash 原版中 "on" 是普通颜色，图标和分支是彩色的
  echo " on ${git_color} ${git_symbol} ${zim_git_info_keys[branch]}%f%b"
}

# 4. 组装 PROMPT
# %B%F{blue}...%f%b : 粗体蓝色
# %~                : 当前路径 (如 ~)
# $(...)            : 调用上面的 git 函数
# \n❯               : 换行 + 箭头符号

# PROMPT='%B%F{blue}%~%f%b$(prompt_nekolight_git)
PROMPT='%B%F{blue}%~%f%b$(prompt_nekolight_git)
%(?,%B%F{green}❯%f%b,%B%F{red}❯%f%b) '
❯ '
