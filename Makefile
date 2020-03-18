# 1) exclude local git files from being linked
# 2) and exclude .ssh to prevent linking over an already existing ~/.ssh directory
EXCLUSIONS := .git .gitignore .gitmodules %.swp .ssh .. .
SOURCES := $(filter-out $(EXCLUSIONS),$(wildcard .*))
DOTFILES := $(addprefix ${HOME}/, $(SOURCES))
SOURCEDIRS := $(shell find $(CURDIR) -maxdepth 1 -mindepth 1 -type d)
DOTDIRS := $(subst $(CURDIR),$(HOME),$(SOURCEDIRS))
# 1) add target dotfile ~/.gitignore to link the non-hidden gitignore in this repo
# 2) add .ssh/config to link the exact file (not direcotry) to ~/.ssh/config
DOTFILES += ${HOME}/.gitignore ${HOME}/.ssh/config

DISTRO=$(shell lsb_release -si)
ifeq ($(DISTRO), Ubuntu)
	INSTALLER=apt
	DEPS=powerline fonts-powerline curl
endif
ifeq ($(DISTRO), Fedora)
	INSTALLER=dnf
	DEPS=powerline powerline-fonts
endif

.PHONY: all dotfiles vim test gnome
all: dotfiles vim

vim: ${HOME}/.vim
	@echo "setting up git"
	sudo $(INSTALLER) install -y $(DEPS)
	cd .vim
	git submodule update --init --recursive
	git submodule foreach git pull --recurse-submodules origin master
	mkdir -p ${HOME}/.vim/autoload
	curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

dotdirs: $(DOTDIRS)
	$(DOTDIRS)

$(DOTDIRS):: ${HOME}/%: ${PWD}/%
	ln -sf $< $@

dotfiles: $(DOTFILES)
#	git update-index --skip-worktree $(CURDIR)/.gitconfig

# create the ~/.ssh directory if it does not exist yet
${HOME}/.ssh/config::
	test -d ${HOME}/.ssh || mkdir ${HOME}/.ssh

# use double colon to allow multiple targets per file for target-specific override of this catchall rule
# targets : target-pattern: prereq-patterns. See https://www.gnu.org/software/make/manual/html_node/Static-Usage.html#Static-Usage
$(DOTFILES):: ${HOME}/%: ${PWD}/%
	@ln -sf $< $@

# override the default rule where this repo's .gitignore is linked to ~/
${HOME}/.gitignore::
	ln -sf ${CURDIR}/gitignore $@

gnome: shell-button-bg
	sudo $(INSTALLER) install -y gnome-icon-theme

shell-button-bg:
	# remove panel button background on XO_Catalina
	sed -i '/#panel .panel-button:active, #panel .panel-button:overview, #panel .panel-button:focus, #panel .panel-button:checked {/,/}/{s/background-color: #0e6bff;//g}' /usr/share/themes/XO_Catalina/gnome-shell/gnome-shell.css

.PHONY:
lockscreen-login-box:
	sudo sed -i '/.login-dialog-user-list:expanded .login-dialog-user-list-item:selected {/,/}/{s/background-color: .*/background-color: #0E4D92;/g}' /usr/share/gnome-shell/theme/ubuntu.css

lockscreen-blurred: LOCKSCREEN=/usr/share/backgrounds/lockscreen-blurred$(suffix $(shell gsettings get org.gnome.desktop.background picture-uri|tr -d \'))

.PHONY:
lockscreen-blurred:
	sudo convert $(shell gsettings get org.gnome.desktop.background picture-uri) \
                -blur "0x5" \
                $(LOCKSCREEN)
	@sudo sed -i '/#lockDialogGroup {/,/}/c \
                #lockDialogGroup { \
                background: #0E4D92 url(file://$(LOCKSCREEN)); \
                background-repeat: no-repeat; \
                background-size: cover; \
                background-position: center; \
                }' /usr/share/gnome-shell/theme/gnome-shell.css
