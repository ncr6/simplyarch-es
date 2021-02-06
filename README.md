<p align="center">
  <a href="https://github.com/victor-bayas/simplyarch">
    <img src="img/laptop.png" alt="laptop-mockup" height="200">
  </a>
  <h1 align="center">SimplyArch Installer (UEFI & BIOS)</h1>
  <p align="center">
    La manera más sencilla de instalar un sistema Arch Linux base sin bloatware 
  </p>
</p>

## Descargo de responsabilidad
EL SOFTWARE SE PROPORCIONA "TAL CUAL", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O IMPLÍCITA
# Pre-requisitos 🔎
- Una conexión a Internet que funcione.
- **Ser un usuario intermedio/avanzado.**
- Un disco previamente particionado.
- **Solamente compatible con UEFI** (próximamente versión BIOS).
## Sistemas de archivos compatibles
- ext4
- **(NUEVO)** Soporte inicial para **btrfs** (gracias a [@lenuswalker](https://github.com/lenuswalker))
# Lo que este script hará ✅
- Instalar un sistema base funcional.
- Configurar su teclado, configuraciones regionales, zona horaria y nombre de host.
- Crear un usuario estándar con permisos para ejecutar órdenes `sudo`.
- Instalar utilidades como `vim` `nano` `htop` `neofetch` y nuestra herramienta `simple_reflector.sh` .
- **(NUEVO)** Instala `paru` como asistente de AUR en lugar de `yay`.
# Lo que este script NO hará 🚫
- Instalar cualquier controlador no incluido en el kernel.
- Instalar algún entorno de escritorio (DE), gestor de ventanas (WM) o cualquier otra aplicación con interfaz gráfica de usuario (GUI).
- Tomar decisiones por usted.
# ¿Cómo usarlo? 📖
- Arranque [la última ISO de Arch Linux](https://archlinux.org/download/)
- Cargue su distribución de teclado, utilizando por ejemplo el comando `loadkeys la-latin1`.
- Conéctese a internet.
- Particione el disco con la herramienta de su elección.
- Instale `git` con el comando `pacman -Sy git`
- Clone este repositorio, utilizando el comando `git clone https://github.com/victor-bayas/simplyarch`
- Ejecute el script con `./simplyarch-uefi.sh` y siga las instrucciones en pantalla.
# ¿Y luego? ❓
- Instale los controladores no incluidos con el kernel si su hardware lo requiere (por ejemplo, Nvidia, Broadcom, VAAPI, etc.).
- Instale el entorno de escritorio o gestor de ventanas de su elección, junto a cualquier otra aplicación que necesite.
