# Natulit
This is a hacky, amateurish solution for automatic management of screen brightness based on time. You should not use this script in place of proper programs — unless you have a good reason to.

## Dependencies
ddcutil <br>
sudo <br>

## Usage
First, you need to create a configuration file in "~/.config/natulit/config". The syntax is simple:

```
10:00 90

12:15 100

18:00 30

18:30 0
```

You only need to type a H:M time followed by a brightness percentage. Each entry must be separated by at least one newline. The times must be in an ascending order; otherwise, some values will be skipped. Everything else is ignored as long as it does not contain a colon.

Next, you need to make "sudo ddcutil" passwordless (a questionable idea!). To do that, append to your /etc/sudoers file:

```
ALL ALL=NOPASSWD: /usr/bin/ddcutil
```

Now you are set. For convenience, you should autostart this script with your DE or WM.

## Troubleshooting

Your monitor could be using different values than the program expects (in fact, that is very likely to be the case, and a good reason to not use this script). To fix that, first find out which VCP feature controls the brightness:

```
sudo ddcutil capabilities
```

You should find something like this:

```
Feature: 10 (Brightness)
```

Now in the script, replace "10" with the appropriate number in this line:

```
sudo ddcutil setvcp 10 ${array_values[index]} --bus 0
```

You may also need to replace the bus number.

## Todo

* More configuration options
* Simpler usage
* Dynamic timing


