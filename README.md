#Modular Arch Installer
This is an Arch installer that follows the upstream KISS principle.
Nothing stops it from being just an Arch installer, but that is what it ships as by default.

##Doesn't the installer in Archboot do this? Is this just NIH-syndrome at work?
Sure, it does it, but it's messy, coupled with Archboot itself, and it doesn't really follow [The Arch Way](https://wiki.archlinux.org/index.php/The_Arch_Way).
I attempted to follow it, and it adheres to it fairly well. See the table below.

<table>
	<tr>
		<th>Principle</th>
		<th>Archboot</th>
		<th>Modular Arch Installer</th>
	</tr>
    <tr>
        <td>Simplicity</td>
		<td>The entire installer source is defined in a single file, setup. Adding steps require modifying the source directly,
		making sharing steps requiring use of diff and patch.</td>
		<td>The installer is split into multiple files, adding a step is as simple as adding a file. Steps can be shared, they
		are concatted together at build time.</td>
    </tr>
	<tr>
		<td>Code-correctness over convenience</td>
		<td>The DRY principle is heavily applied, and you have to skip around in the file to get a gist of how it works.</td>
		<td>The DRY is a little more loose - only the largest convenience method and APIs that can change internally are made into
		functions. Code is logically split into easier-to-digest files.</td>
	</tr>
	<tr>
		<td>User-centric</td>
		<td>User experience is well-done. Certain non-standard files are installed, but nothing too major. Supports almost everything.</td>
		<td>No non-standard files are installed, it essentially follows the install guide. It is missing some features, most notably the more
		obscure ones, but those who will use them know how to install manually.</td>
	</tr>
	<tr>
		<td>Openness</td>
		<td>The code that is run can be modified directly due to it being written in Shell language.</td>
		<td>See to the left, plus changes pre-compilation is easy.</td>
	</tr>
	<tr>
		<td>(User) Freedom</td>
		<td>Coupled with Archboot, not distributed outside Archboot. Archboot adds non-standard files to the install as well.</td>
		<td>Has a small set of dependencies, can be installed and used for pretty much everything. The only non-standard package installed is
		bash-completion and GRUB.</td>
	</tr>
</table>

#Usage
All `.part.sh` files in `PostInstall` and `PreInstall` is compiled into `install.sh` with `build.sh`.
To use the default, just run `build.sh` and then `install.sh`. Follow the instructions in the script.

If you wish to modify it, add stages that run on the Arch ISO itself in `PreInstall`, and add complimentary stages
that run on the bootstrapped system in `PostInstall`. For available helper functions, see `framework.sh`, most notably
`exportPostInstall` which lets you move variables to the `PostInstall` stage, since `PostInstall` runs in a different
"scope" of sorts.

#License
MIT License, really, since it's not too advanced, and we use this commercially, so why shouldn't you be able to?