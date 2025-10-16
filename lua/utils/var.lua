local M = {}

---@alias Env "Windows"|"Linux"|"WSL"|"OSX"|"BSD"|"POSIX"|"Other"

--- Current environment
---@type Env
M.env = os.getenv("WSL_DISTRO_NAME") and "WSL" or jit.os

return M
