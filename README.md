# NoShort

Get rid of that pesky and unsightly "shortcut arrow" on your Windows desktop easily!

## Solution

1. Open PowerShell as an Admin (`Windows + X`, then hit `A`)
2. Paste the magic line :shipit::
```
irm -Uri 'https://raw.githubusercontent.com/nxvvvv/noshort/main/noshort.ps1' -UseBasicParsing | iex
```
3. Press `1` to **Remove** the Shortcut arrow

> [!NOTE]
> Feeling nostalgic? Press `2` to Revert the changes

## "Why should I pick this over other methods?"

Hey, it's totally up to you! I've tried the popular ones, and those were just meh. This method? Clean, efficient, and won't give you a headache like those other arrow-removing shenanigans. Your Desktop, your rules!

#### The Classic method:

1. Open `regedit`
2. Navigate to `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer`
3. Create a new key `(Explorer > New > Key)` named Shell Icons
4. Select Shell Icons, then create a new String Value `(New > String Value)` named `29`
5. Double-click `29` and enter `%windir%\System32\shell32.dll,-50` in the data text box
6. Restart `explorer.exe`

But here's what you might end up with :neutral_face::
<img src="https://github.com/nxvvvv/noshort/assets/34748927/b9092d7e-07b1-444b-8154-72326cde0207" width="55">

So, my way? It's just simpler and works better.
