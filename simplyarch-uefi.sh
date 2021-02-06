#!/bin/bash
clear
echo
echo "Bienvenido al Instalador SimplyArch (UEFI)"
echo "Copyright (C) 2021 Victor Bayas"
echo "Traducción al español por Nícolas Castillo"
echo
echo "DESCARGO DE RESPONSABILIDAD:"
echo "EL SOFTWARE SE PROPORCIONA ""TAL CUAL"", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O IMPLÍCITA"
echo
echo "ADVERTENCIA: Asegúrese de ingresar correctamente los datos, este programa no validará el texto que ingrese."
echo
echo "Lo guiaremos a través del proceso de instalación de un sistema Arch Linux base funcional."
echo
echo "\"btw btw btw btw btw btw\""
echo "- un usuario de SimplyArch satisfecho."
echo
read -p "¿Desea continuar? (S/N): " prompt
if [[ $prompt == "s" || $prompt == "S" || $prompt == "si" || $prompt == "Si" || $prompt == "sí" || $prompt == "Sí" ]]
then
	#timedatectl set-ntp true
	clear
	# Solicitando datos regionales
	echo ">>> [ REGIÓN E IDIOMA ] <<<"
	echo
	echo "Ingrese el código de su distribución del teclado. Ejemplo:"
	echo
	echo "us (Estados Unidos) | us-acentos (Estados Unidos internacional con tildes)"
	echo "latam (Español Latinoamericano) | es (Español de España)"
	echo 
	read -p "Su distribución de teclado: " keyboard 
	if [ -z "$keyboard" ]
	then
		keyboard="latam"
	fi
	#echo
	#echo "EXAMPLES: America/New_York | Europe/Berlin"
	#read -p "Timezone: " timezone
	echo
	echo "A continuación configuraremos su idioma y región."
	echo
	echo "Ingrese el código de idioma y región. Por ejemplo:"
	echo
	echo "en_US (Instalará un sistema en Inglés de Estados Unidos)."
	echo "es_ES (Instalará un sistema en Español de España)"
	echo "es_MX (Instalará un sistema en Español de México)"
	echo "es_CO (Instalará un sistema en Español de Colombia)"
	echo "es_CL (Instalará un sistema en Español de Chile)"
	echo "es_PE (Instalará un sistema en Español de Perú)"
	echo "es_AR (Instalará un sistema en Español de Argentina)"
	echo
	read -p "Código de idioma y región: " locale
	if [ -z "$locale" ]
	then
		locale="en_US"
	fi
	clear
	# Solicitando datos de la cuenta de usuario
	echo ">>> [ CONFIGURACIÓN DE LA CUENTA DE USUARIO Y EL NOMBRE DEL HOST ] <<<"
	echo
	echo "El hostname es el nombre con el que esta máquina se identificará ante los programas"
	echo "y demás dispositivos de su red, es un equivalente al Nombre del Equipo en sistemas Windows"
	echo "Además, es el nombre que aparecerá en su Terminal. ([usuario@hostname ~] $)"
	echo
	read -p "Ingrese el hostname para esta máquina: " hostname
	echo
	echo "Perfecto. A continuación configuraremos la contraseña del superusuario (root)."
	echo "Se recomienda que esta cuenta de usuario sea utilizada solamente para tareas administrativas"
	echo
	echo "Elija una contraseña segura, ya que este usuario tendrá privilegios totales sobre su sistema."
	echo
	read -sp "Contraseña del usuario root: " rootpw
	echo
	read -sp "Ingrésela nuevamente (para verificar): " rootpw2
	echo
	while [ $rootpw != $rootpw2 ]
	do
		echo
		echo "Las contraseñas ingresadas no coinciden. Intentémoslo otra vez."
		echo
		read -sp "Contraseña del usuario root: " rootpw
		echo
		read -sp "Ingrésela nuevamente (para verificar): " rootpw2
		echo
	done
	echo
	echo "Ajustes guardados."
	echo
	echo "A continuación configuraremos su cuenta de usuario personal, esta será la cuenta que usará"
	echo "para iniciar sesión, ejecutar programas y guardar archivos."
	echo
	echo "Le recomendamos elegir un nombre o apodo corto, evitando espacios y símbolos."
	echo
	read -p "Nombre de usuario: " user
	read -sp "Contraseña de su cuenta de usuario: " userpw
	echo
	read -sp "Ingrésela nuevamente (para verificar): " userpw2
	echo
	while [ $userpw != $userpw2 ]
	do
		echo
		echo "Las contraseñas ingresadas no coinciden. Intentémoslo otra vez."
		echo
		read -sp "Contraseña de su cuenta de usuario: " userpw
		echo
		read -sp "Ingrésela nuevamente (para verificar): " userpw2
		echo
	done
	# Configuración de los discos
	clear
	echo ">>> [ AJUSTES DEL DISCO ] <<<"
	echo
	echo "IMPORTANTE: Asegúrese de tener su disco previamente particionado."
	echo
	echo "Si no está seguro, tiene 5s para presionar Ctrl+C, particionar su disco y ejecutar este script nuevamente."
	sleep 5
	clear
	echo "Tabla de particiones: "
	echo
	lsblk
	echo
	while ! [[ "$partType" =~ ^(1|2)$ ]] 
	do
		echo "Seleccione el tipo de particiones que ha realizado."
		echo "Ingrese 1 si es ext4. "
		echo "Ingrese 2 si es btrfs."
		echo
		read -p "Tipo de partición: " partType
	done
	clear
	echo "Tabla de particiones: "
	echo
	lsblk
	echo
	echo "Escriba el nombre la partición principal. "
	echo "Por ejemplo: /dev/sdaX /dev/nvme0n1pX"
	echo
	read -p "Partición principal: " rootPart
	case $partType in
		1)
			mkfs.ext4 $rootPart
			mount $rootPart /mnt
			;;
		2)
			mkfs.btrfs -f -L "Arch Linux" $rootPart
			mount $rootPart /mnt
			btrfs sub cr /mnt/@
			umount $rootPart
			mount -o relatime,space_cache=v2,compress=lzo,subvol=@ $rootPart /mnt
			mkdir /mnt/boot
			;;
	esac
	clear
	echo "Tabla de particiones: "
	echo
	lsblk
	echo
	while ! [[ "$bootType" =~ ^(1|2)$ ]] 
	do
		echo "Por favor seleccione el tipo de arranque de su sistema."
		echo
		echo "Ingrese 1 para UEFI. "
		echo "Ingrese 2 para BIOS."
		echo
		read -p "Tipo de arranque: " bootType
	done
	clear
	if [ $bootType == 1 ]
	then
		echo "Tabla de particiones: "
		echo
		lsblk
		echo
		echo "Escriba el nombre de la partición de arranque EFI. "
		echo "Por ejemplo: /dev/sdaX /dev/nvme0n1pX"
		echo
		read -p "Partición de arranque EFI: " efiPart
		echo
		echo "[ADVERTENCIA PARA USUARIOS QUE REALIZAN DUAL BOOT] "
		echo "Si está compartiendo esta partición con algún otro sistema operativo, ingrese N a continuación."
		echo
		read -p "¿Desea formatear esta partición como FAT32? (S/N): " formatEFI
		if [[ $formatEFI == "s" || $formatEFI == "S" || $formatEFI == "si" || $formatEFI == "Si" || $formatEFI == "sí" || $formatEFI == "Sí" ]]
		then
			mkfs.fat -F32 $efiPart
		fi
		mkdir -p /mnt/boot/efi
		mount $efiPart /mnt/boot/efi
		echo
		clear
	fi
	echo "Tabla de particiones: "
	echo
	lsblk
	echo
	echo "NOTA: Si no desea utilizar una partición de intercambio (swap), ingrese N a continuación."
	echo
	echo "Escriba el nombre de la partición de intercambio (swap)"
	echo "Por ejemplo: /dev/sdaX /dev/nvme0n1pX"
	echo
	read -p "Partición de intercambio: " swap
	if [[ $swap == "n" || $swap == "N" || $swap == "no" || $swap == "No" ]]
	then
		echo
		echo "No se seleccionó ninguna partición de intercambio (swap)."
		sleep 1
	else
		mkswap $swap
		swapon $swap
	fi
	clear
	# Actualizar los mirrors
	echo "A continuación se actualizarán los mirrors de los repositorios del gestor de paquetes."
	echo
	sleep 1
	chmod +x simple_reflector.sh
	./simple_reflector.sh
	clear
	echo ">>> [ INSTALACIÓN Y CONFIGURACIÓN DEL SISTEMA BASE ] <<<"
	echo
	echo "Hemos configurado todos los detalles de su sistema base."
	echo
	echo "A continuación procederemos a instalarlo con los detalles especificados."
	echo
	echo "Este proceso puede tardar bastante tiempo"
	echo
	echo "Tiene 10s para cancelar la instalación presionando Ctrl + C en caso así lo desee."
	sleep 10
	echo
	echo "Procediendo con la instalación..."
	echo
	sleep 2
	# Install base system
	if [ $bootType == 1 ]
	then
		pacstrap /mnt base base-devel linux linux-firmware linux-headers grub efibootmgr os-prober bash-completion sudo nano vim networkmanager ntfs-3g neofetch htop git reflector xdg-user-dirs e2fsprogs man-db
	else
		pacstrap /mnt base base-devel linux linux-firmware linux-headers grub os-prober bash-completion sudo nano vim networkmanager ntfs-3g neofetch htop git reflector xdg-user-dirs e2fsprogs man-db
	fi
	# Fstab
	genfstab -U /mnt >> /mnt/etc/fstab
	nano /mnt/etc/fstab
	# configure base system
	# locales
	echo "$locale.UTF-8 UTF-8" >> /mnt/etc/locale.gen
	arch-chroot /mnt /bin/bash -c "locale-gen" 
	echo "LANG=$locale.UTF-8" > /mnt/etc/locale.conf
	# timezone
	arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /etc/localtime"
	arch-chroot /mnt /bin/bash -c "hwclock --systohc"
	# keyboard
	echo "KEYMAP="$keyboard"" > /mnt/etc/vconsole.conf
	# enable multilib
	sed -i '93d' /mnt/etc/pacman.conf
	sed -i '94d' /mnt/etc/pacman.conf
	sed -i "93i [multilib]" /mnt/etc/pacman.conf
	sed -i "94i Include = /etc/pacman.d/mirrorlist" /mnt/etc/pacman.conf
	# hostname
	echo "$hostname" > /mnt/etc/hostname
	echo "127.0.0.1	localhost" > /mnt/etc/hosts
	echo "::1		localhost" >> /mnt/etc/hosts
	echo "127.0.1.1	$hostname.localdomain	$hostname" >> /mnt/etc/hosts
	# grub
	if [ $bootType == 1 ]
	then
		arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch"
	else
		arch-chroot /mnt /bin/bash -c "grub-install ${rootPart::-1}"
	fi
	arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
	# networkmanager
	arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
	# root pw
	arch-chroot /mnt /bin/bash -c "(echo $rootpw ; echo $rootpw) | passwd root"
	# create user
	arch-chroot /mnt /bin/bash -c "useradd -m -G wheel $user"
	arch-chroot /mnt /bin/bash -c "(echo $userpw ; echo $userpw) | passwd $user"
	arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
	arch-chroot /mnt /bin/bash -c "xdg-user-dirs-update"
	# update mirrors
	cp ./simple_reflector.sh /mnt/home/$user/simple_reflector.sh
	arch-chroot /mnt /bin/bash -c "chmod +x /home/$user/simple_reflector.sh"
	arch-chroot /mnt /bin/bash -c "/home/$user/simple_reflector.sh"
	clear
	# yay
	echo ">>> [ DETALLES POSTERIORES A LA INSTALACIÓN ] <<<"
	echo
	echo "El sistema base se ha instalado correctamente con los ajustes que ud. indicó en los pasos anteriores."
	echo
	sleep 2
	echo "A continuación se instalará Paru, el asistente para el AUR..."
	echo "cd && git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si --noconfirm && cd && rm -rf paru-bin" | arch-chroot /mnt /bin/bash -c "su $user"
	clear
	echo "Gracias por usar el instalador SimplyArch (UEFI)"
	echo
	echo ">>> [ INSTALACIÓN COMPLETADA ] <<<"
	echo
	echo "El sistema se reiniciará automáticamente en 10 segundos..."
	sleep 10
	clear
	umount -a
	reboot
fi
