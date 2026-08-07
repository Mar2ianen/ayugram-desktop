<h1 align="center">Ayugram desktop 🌐 NixOS flake</h1>

<div align="center">

![GitHub repo size](https://img.shields.io/github/repo-size/ayugram-port/ayugram-desktop?style=for-the-badge&cacheSeconds=180)

![GitHub License](https://img.shields.io/github/license/ayugram-port/ayugram-desktop?style=for-the-badge)
</div>

> [!TIP]
> NEW!!!
> `ayugram-desktop` is already in [nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ay/ayugram-desktop/package.nix)
> but it's an override for `telegram-desktop`, so `Mar2ianen/ayugram-desktop`
> flake is still better, because we don't rely on `telegram-desktop` being able to build -
> and we won't push a broken update.

> [!NOTE]
> We do have binary cache via [Cachix](https://cachix.org/).
> In case you'll setup it manually - make sure to rebuild with
> activated cache **BEFORE** adding `ayugram` your packages.

> [!WARNING]
> Any other architecture than Linux is **NOT SUPPORTED**:
>
> Q: Why?
> A: We don't have any device to test it!
>
> Q: Can I help it?
> A: YES!! If you are user of this kind of system you can
>    become maintainer to add support for your architecture!

<h2 align="center">☄️ Installation Instructions</h2>

1. You'll need to add this repo into your `flake.nix`:

   ```nix
   {
     inputs = {
       nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
       ayugram-desktop = {
         type = "git";
         submodules = true;
         url = "https://github.com/Mar2ianen/ayugram-desktop/";
        };
     };

     outputs = {
       self,
       nixpkgs,
       ayugram-desktop,
       ...
     }: {
       ...
     };
   }
   ```

2. After that, add package into your `environment.systemPackages` or `home.packages`:

   ```nix
   # Nixos configuraion
   {
     pkgs,
     inputs,
     ...
   }: {
     environment.systemPackages = with pkgs; [
       inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
     ];
   }
   ```

   ```nix
   # Home-manager configuration
   {
     pkgs,
     inputs,
     ...
   }: {
     home.packages = with pkgs; [
       inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
     ];
   }
   ```

3. Now rebuild, and feel free to use `ayugram-desktop`!

> [!TIP]
> On any Linux with Nix installed (not just NixOS) you can run it directly:

```sh
# Run without installing
nix run --accept-flake-config github:Mar2ianen/ayugram-desktop

# Install into user profile
nix profile install --accept-flake-config github:Mar2ianen/ayugram-desktop
```

<h2 align="center"> 🐧 Arch Linux (и другие не-NixOS дистрибутивы)</h2>

Если у вас ещё нет Nix — поставьте его на Arch:

```sh
sudo pacman -S nix
sudo systemctl enable --now nix-daemon
```

Затем подключите кэш сборок (бинарники наш уже собраны — локально компилировать НЕ придётся):

```sh
sudo sh -c 'echo "trusted-users = @wheel" >> /etc/nix/nix.conf'
sudo systemctl restart nix-daemon
```

И установите:

```sh
nix profile install --accept-flake-config github:Mar2ianen/ayugram-desktop
```

Библиотека появится в `~/.nix-profile/bin/AyuGram`, запускайте так:

```sh
AyuGram
```

Обновление на новую версию:

```sh
nix profile upgrade ayugram-desktop
```

> [!NOTE]
> `--accept-flake-config` нужен, чтобы Nix разрешил `flakes-кэш` из этого репозитория (substituters уже прописаны в `flake.nix`).

<h2 align="center"> ⚡ Manual Binary Cache Setup</h2>

Simpy add it into your `nix` settings inside nixos configuration:

```nix
nix.settings = {
  substituters = ["https://mar2ianen-ayugram.cachix.org" "https://tg-owt.cachix.org"];
  trusted-public-keys = ["mar2ianen-ayugram.cachix.org-1:lBT/myHhswxz97HLBpkbF+4BWPxltMKoPnfs8Nnw6Q0=" "tg-owt.cachix.org-1:lp0BukIhSK3EIyLcDhDZ5zABgT48nmNp6t4SnZ0wr8w="];
};
```

<h2 align="center"> 🪐 P.S.:</h2>

| Thanks                                            | to                                                                          |
| ------------------------------------------------- | --------------------------------------------------------------------------- |
| 🪐 [shwewo](https://github.com/shwewo)            | for original [repo](https://github.com/shwewo/ayugram-desktop).             |
| 🪐 [kaeeraa](https://github.com/kaeeraa)          | for fork adoption.                                                          |
| 🪐 [AyuGram](https://github.com/AyuGram)          | for the [AyuGramDesktop](https://github.com/AyuGram/AyuGramDesktop) itself. |
| 🪐 [hand7s](https://github.com/s0me1newithhand7s) | for this awesome readme (:D) and some work with package format.             |
