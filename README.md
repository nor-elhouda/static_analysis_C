# static_analysis_C
standards verification of C code
************installation de frama-c dans WSL pour windows**************************

1. installation de wsl : 

  	L'installation de Windows Subsystem for Linux (WSL) a partir de Microsoft Store 

2. installation d'une distrubution ubuntu :

	a partir de Microsoft store 

3.installation de frama-c:

	https://frama-c.com/html/get-frama-c.html

pour la version de frama-c utilise dans ce projet : frama-c 27.1

	# 1. Prepare opam installation
	sudo apt update && sudo apt upgrade
	sudo apt install make m4 gcc opam

	# 2. opam setup
	opam init --disable-sandboxing --shell-setup
	eval $(opam env)
	opam install -y opam-depext

	# 3. Install graphical dependencies
	opam depext --install -y lablgtk3 lablgtk3-sourceview3

	# 4. Install Frama-C
	opam depext --install -y frama-c

	# On WSL2, run the GUI as: GDK_BACKEND=x11 frama-c-gui 

pour plus d'info detaillé: 

	https://git.frama-c.com/pub/frama-c/blob/master/INSTALL.md
