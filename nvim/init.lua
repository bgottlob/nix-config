print('Loading vimrc')
vim.cmd('source ' .. nvimrc .. '/vimrc')
print('Requiring completion')
require 'completion'
