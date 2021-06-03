;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules (gnu) 
	     (gnu system nss)
	     (gnu services base)
	     (gnu services xorg)
	     (gnu services networking)
	     (gnu packages emacs)
	     (gnu packages fonts)
	     (gnu packages gnome)
	     (gnu packages linux)
	     (gnu packages pulseaudio)
	     (gnu packages shells)
	     (gnu packages ssh)
	     (gnu packages terminals)
	     (gnu packages version-control)
	     (gnu packages vim)
	     (gnu packages wm)
	     (nongnu packages linux)
	     (nongnu system linux-initrd))
(use-service-modules networking ssh)
(use-package-modules certs)

(operating-system
  (host-name "ZFminusC")
  (timezone "Europe/Zurich")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "ch"))

  ;; non-free Linux Kernel and firmware
  (kernel linux)
  (firmware (list linux-firmware))
  (initrd microcode-initrd)


  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")
                (keyboard-layout keyboard-layout)))

  ;; Specify a mapped device for the encrypted root partition.
  ;; The UUID is that returned by 'cryptsetup luksUUID'.
  (mapped-devices
   (list (mapped-device
          (source (uuid "a91f7440-be65-4e5b-91f6-7f9fd6ce3ad7"))
          (target "ROOT")
          (type luks-device-mapping))))
  ;; Add entry per subvolume
  (file-systems (append
                 (list (file-system
                         (device (file-system-label "ROOT"))
                         (options "subvol=@guix")
                         (mount-point "/")
                         (type "btrfs")
                         (dependencies mapped-devices))
                       (file-system
                         (device (file-system-label "ROOT"))
                         (options "subvol=@guixhome")
                         (mount-point "/home")
                         (type "btrfs")
                         (dependencies mapped-devices))
                       (file-system
                         (device (file-system-label "ROOT"))
                         (options "subvol=@guixsnapshots")
                         (mount-point "/snapshots")
                         (type "btrfs")
                         (dependencies mapped-devices))
                       (file-system
                         (device (file-system-label "EFI"))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (users (cons (user-account
                (name "hk")
                (comment "Han-Miru Kim")
                (group "users")
                (supplementary-groups '("wheel"    ;; sudo
					"netdev"
					"tty"
					"input"
                                        "audio" 
					"video"
					"lp")))	   ;; bluetooth
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (append (list
		     alacritty
		     btrfs-progs
		     emacs
		     font-dejavu
		     ghc-xmonad-contrib
		     git
                     nss-certs
		     pulseaudio
		     vim
		     xmonad
		     zsh) 
                    %base-packages))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss)
  ;; Services
  (services (append (list (service dhcp-client-service-type)
			  (service openssh-service-type
				   (openssh-configuration
				     (openssh openssh-sans-x)
				     (port-number 2222))))
		    %base-services)))


