set mouse=a
set linespace=0
set signcolumn=yes

if exists(':GuiFont')
  GuiFont! MesloLGM\ Nerd\ Font\ Mono:h12
endif

if exists(':GuiTabline')
  GuiTabline 0
endif

if exists(':GuiPopupmenu')
  GuiPopupmenu 0
endif

if exists(':GuiScrollBar')
  GuiScrollBar 1
endif
