DOT_FILES = .zshrc .zsh .dir_colors .gitconfig .gitignore .ctags .bash_profile
CURRENTDIR = $(shell pwd)
BACKUPDIR = $(HOME)/.dotfiles.bk

all: backup clean install

install: depends zsh git dircolors ctags bash_profile

depends:
	git submodule update --init

backup: make-backup-dir $(foreach f, $(DOT_FILES), backup-dot-files-$(f))

restore: clean $(foreach f, $(DOT_FILES), restore-dot-files-$(f))

remove: restore  $(foreach f, $(DOT_FILES), remove-dot-files-$(f))

clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))

zsh: $(foreach f, $(filter .zsh%, $(DOT_FILES)), link-dot-file-$(f))


git: $(foreach f, $(filter .git%, $(DOT_FILES)), link-dot-file-$(f))

dircolors: $(foreach f, $(filter .dir_colors%, $(DOT_FILES)), link-dot-file-$(f))

ctags: $(foreach f, $(filter .ctags%, $(DOT_FILES)), link-dot-file-$(f))

bash_profile: $(foreach f, $(filter .bash_profile%, $(DOT_FILES)), link-dot-file-$(f))

make-backup-dir:
	mkdir -p $(BACKUPDIR)

link-dot-file-%: %
	@echo "Create Symlink $(shell echo $< | sed "s/^.//") => $(HOME)/$<"
	@ln -snf $(CURRENTDIR)/$(shell echo $< | sed "s/^.//") $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@rm -rf $(HOME)/$<

restore-dot-files-%: %
	@if [ -f $(BACKUPDIR)/$< -o -d $(BACKUPDIR)/$< ]; then \
    echo "Restore $(BACKUPDIR)/$< => $(HOME)/$<";\
    cp -rp $(BACKUPDIR)/$< $(HOME)/;\
  fi

backup-dot-files-%: %
	@if [ \( -f $(HOME)/$< -o -d $(HOME)/$< \) -a ! -L $(HOME)/$< ]; then \
    echo "Create Backup $(HOME)/$< => $(BACKUPDIR)/$<";\
    cp -rp $(HOME)/$< $(BACKUPDIR)/;\
  fi

remove-dot-files-%: %
	@if [ -f $(HOME)/$< -o -d $(HOME)/$< ]; then \
    echo "Remove $(HOME)/$<";\
    rm -rf $(HOME)/$< ;\
  fi

.PHONY: clean $(DOT_FILES)
