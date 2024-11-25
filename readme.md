# 🌸 Carnivore Game

Welcome to **Carnivore**, a game developed in **assembly language** using the ICMC processor from the University of São Paulo! This README will guide you through setting up the simulator and running the game.

---

## 🎮 About the Game

Carnivore is a retro-style game designed for the ICMC processor. Test your skills and enjoy a unique gaming experience!

---

## 🛠️ Simulator Installation

🛠️ How to Compile from Source Code

    Install a recent version of Go (at least 1.13) from here.
    Install Git and a C compiler (on Windows, use MinGW).
    On Debian/Ubuntu-based systems, install libgl1-mesa-dev xorg-dev; on Fedora and Red Hat-based systems, install libX11-devel libXcursor-devel libXrandr-devel libXinerama-devel mesa-libGL-devel libXi-devel libXxf86vm-devel.
    Clone the repository and navigate to the project directory.
    Run go build . to compile and ./goICMCsim to start an empty processor. Use --help to see command line options.
    Optionally, you can install directly into $GOPATH/bin with go install github.com/lucasgpulcinelli/goICMCsim@latest.

---

## 🖼️ Processor Architecture

![Processor Architecture](readme.md/architecture.png)

The image above illustrates the architecture of the ICMC processor, providing an overview of its components and design principles.

---

## 🚀 Running the Game

1. Compile the **Carnivore** game assembly code.
2. Load the compiled game into the simulator.
3. Start playing!

---

## 💡 Tips

- Use the `--help` option in the simulator to explore its features.
- Check the [simulator's repository](https://github.com/lucasgpulcinelli/goICMCsim/tree/v1.1) for detailed information.

---

## 📄 License

This project is licensed under the terms specified in the [Carnivore Game] repository.

Enjoy the hunt! 🌱🎯

