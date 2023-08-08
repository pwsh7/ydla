# =====================================
#        Script Author: Snixf
#        Github.com/snixf
# =====================================
#        Version: 2.2
#       PS Version: 7.x.x
# =====================================

#script starts here

$ffmpeg_location="`"C:\ProgramData\chocolatey\lib\ffmpeg\tools\ffmpeg\bin\ffmpeg.exe`""
$output_location="`"$HOME\Downloads\%(title)s.%(ext)s`""
$options="--no-mtime --ffmpeg-location $ffmpeg_location --output $output_location"



function Set-Format {
	Switch ($choice)
	{
		1 {Write-Output $null}
		2 {Write-Output "-f best"}
		3 {Write-Output "-f bestvideo+bestaudio/best --merge-output-format mp4"}
		4 {Write-Output -f $format --merge-output-format mp4}
		5 {Write-Output -f $format}
	}
}


function Check-Format {
	Write-Host "Output will be: " 
	Write-Host (& ./youtube-dl.exe $format $URL --get-format)
	Read-Host "Ok? (Enter Y/N)"
}


function Custom-Formats {
	# Write-Host "I am inside custom-formats" #For Testing
	if ($choice -eq 4) {Write-Host "INSTRUCTIONS: Choose the format codes for the video and audio quality you want from the list at the top. ffmpeg must be installed and location specified in batch file."
		$videoFormat = Read-Host "Video Format Code"
		$audioFormat = Read-Host "Audio Format Code"
		$chosenFormat = ${videoFormat}+"+"+${audioFormat}
		Write-Output $chosenFormat 
	}
	else { if ($choice -eq 5) {Write-Host "INSTRUCTIONS: Choose the format code for the video or audio quality you want from the list at the top."
		$chosenFormat = Read-Host "Format Code"
		Write-Output $chosenFormat
		 }
	}
}


function Update-Program{
	& ./youtube-dl.exe --update
	exit
	}
	

Write-Output ""
Write-Output '--------------------------------- YouTube-dl Advanced ---------------------------------'
Write-Output ""
Write-Output ""
$URL = Read-Host "Enter video URL here"

# Lists all formats for video
Write-Output ""
& ./youtube-dl.exe --list-formats $URL

# While loop until user is satisfied with output and confirms using Check-Format function
while ($confirm -ne "y") {
	Write-Output ""
	Write-Output "---------------------------------------------------------------------------"
	Write-Output "Options:"
	Write-Output "1. Download automatically (default is best video + audio muxed)"
	Write-Output "2. Download the best quality single file, no mux"
	Write-Output "3. Download the highest quality audio + video formats, attempt merge to mp4"
	Write-Output "4. Let me choose the video and audio formats to combine"
	Write-Output "5. Download ONLY audio or video"
	Write-Output "6. -UPDATE PROGRAM- (Admin May Be Required)"
	Write-Output ""

	$choice = Read-Host "Type your choice number" #Takes in choice from user
	if (($choice -eq 4)	-or ($choice -eq 5)) { $format = Custom-Formats }
	if ($choice -eq 6) {Update-Program}
	$format = Set-Format
	$confirm = Check-Format
}
