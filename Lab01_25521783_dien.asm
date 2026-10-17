# $s0 = x ; $s1 = tong tien ; $s2 = can duoi
# $s3 = con tro mang nguong ; $s4 = con tro mang don gia
.data
Nguong: .word 50, 100, 200, 300, 400, 9999
gia:    .word 1660, 1720, 2010, 2560, 2910, 3060
prompt_Nkwh: .asciiz "Nhap so kWh (0..9999): "
loi:    .asciiz "Gia tri khong hop le, nhap lai.\n"
kq1:    .asciiz "Tien dien: "
kq2:    .asciiz " dong\n"
.text 
main: 
nhap:
li $v0, 4
la $a0, prompt_Nkwh
syscall 

li $v0, 5
syscall 
move $s0, $v0 

sltiu $t0, $s0, 10000     
bne   $t0, $zero, tinh
sai: 
li $v0, 4
la $a0, loi
syscall 
j nhap

tinh: 
li $s1, 0
li $s2, 0
la $s3, Nguong
la $s4, gia
lap: 
ble $s0, $s2, thoatlap
lw   $t0, 0($s3)          # t0 = can_tren
move $t1, $s0             # gia su min = x
blt $s0, $t0, giu 
move $t1, $t0 
giu:
sub $t1, $t1, $s2
lw $t2, 0($s4)
mul $t2, $t1, $t2
add $s1, $s1, $t2
move $s2, $t0
 addi $s3, $s3, 4          # sang phan tu ke tiep cua mang nguong
addi $s4, $s4, 4          # sang phan tu ke tiep cua mang gia
j    lap
thoatlap: 
li $v0, 4
la $a0, kq1
syscall 
li   $v0, 1
move $a0, $s1          # in tong tien
syscall
li   $v0, 4
la   $a0, kq2          # in " dong\n"
syscall

li   $v0, 10           # ket thuc chuong trinh
syscall
