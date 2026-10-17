# $s0: bien dem vong lap (i)
# $s1: so luong not nhac (15)
# $s2: dia chi mang cao do
# $s3: dia chi mang do dai
# $s4: tong thoi gian du kien tinh cong don (ms)
# $s6: thoi gian bat dau
# $s7: thoi gian ket thuc
.data
cao_do: .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
do_dai: .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
so_not_nhac: .word 15
chuoi_khoang_trang: .asciiz " "
chuoi_xuong_dong:   .asciiz "\n"
chuoi_tong_du_kien: .asciiz "Tong du kien (ms): "
chuoi_thoi_gian_do: .asciiz "Thoi gian do duoc (ms): "
.text
main:
        # Lay thoi gian he thong bat dau (syscall 30)
        li $v0, 30
        syscall
        move $s6, $a0       # Luu 32 bit thap thoi gian bat dau vao $s6

        # Khoi tao tham so vong lap
        li $s0, 0           # i = 0
        lw $s1, so_not_nhac # So luong not (15)
        la $s2, cao_do      # Dia chi co so mang cao do
        la $s3, do_dai      # Dia chi co so mang do dai
        li $s4, 0           # Tong du kien = 0

vong_lap:
        beq $s0, $s1, ket_thuc_lap

        # 1. Doc va tinh cao do: cao_do[i] + a
        sll $t0, $s0, 2     # i * 4 (byte offset)
        add $t1, $s2, $t0   # Dia chi cao_do[i]
        lw $t2, 0($t1)      # $t2 = cao do
        addi $t2, $t2, 3    # Dich giong cong a = 3 

        # 2. Doc do dai va tinh thoi luong (ms): do dai * 230
        add $t3, $s3, $t0   # Dia chi do_dai[i]
        lw $t4, 0($t3)      # Doc do dai 
        li $t5, 230         # 1 nhip = 230ms
        mul $t6, $t4, $t5   # $t6 = thoi luong (ms)
        
        # Cong don tong thoi gian du kien
        add $s4, $s4, $t6

        # 3. In ra console "<cao do> <ms>"
        move $a0, $t2
        li $v0, 1
        syscall

        la $a0, chuoi_khoang_trang
        li $v0, 4
        syscall

        move $a0, $t6
        li $v0, 1
        syscall

        la $a0, chuoi_xuong_dong
        li $v0, 4
        syscall

        # 4. Phat MIDI voi syscall 33 (Phat va tu dong cho)
        move $a0, $t2       # $a0 = Cao do
        move $a1, $t6       # $a1 = Thoi luong (ms)
        li $a2, 0           # $a2 = Nhac cu: 0
        li $a3, 100         # $a3 = Am luong: 100
        li $v0, 33          # Nap so hieu syscall 33
        syscall

        # 5. Tang i va lap lai
        addi $s0, $s0, 1
        j vong_lap

ket_thuc_lap:
        # Lay thoi gian he thong ket thuc (syscall 30)
        li $v0, 30
        syscall
        move $s7, $a0       # Luu thoi gian ket thuc vao $s7
        
        # Tinh thoi gian do duoc = ket thuc - bat dau
        sub $s5, $s7, $s6

        # In tong du kien
        la $a0, chuoi_tong_du_kien
        li $v0, 4
        syscall
        move $a0, $s4
        li $v0, 1
        syscall
        la $a0, chuoi_xuong_dong
        li $v0, 4
        syscall

        # In thoi gian do duoc
        la $a0, chuoi_thoi_gian_do
        li $v0, 4
        syscall
        move $a0, $s5
        li $v0, 1
        syscall
        la $a0, chuoi_xuong_dong
        li $v0, 4
        syscall

        # Ket thuc chuong trinh (syscall 10)
        li $v0, 10
        syscall