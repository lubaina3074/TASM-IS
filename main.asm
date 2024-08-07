.model small
.stack 100h

.data
    mainMenu db "Mini Grocery Inventory System", 0Dh, 0Ah
             db "1. View Inventory", 0Dh, 0Ah
             db "2. Sell Item", 0Dh, 0Ah
             db "3. Restock Item", 0Dh, 0Ah
             db "4. Exit", 0Dh, 0Ah
             db "Enter the corresponding number for the desired action: $", 0Dh, 0Ah, 0Dh, 0Ah


    
    restock_milk db 0Dh, 0Ah,"Milk has been restocked", 0Dh, 0Ah, "$"
    restock_Bread db 0Dh, 0Ah,"Bread has been restocked", 0Dh, 0Ah, "$"
    restock_Eggs db 0Dh, 0Ah,"Eggs has been restocked", 0Dh, 0Ah, "$"
    restock_Apples db 0Dh, 0Ah,"Apples has been restocked", 0Dh, 0Ah, "$"
    restock_Spinach db 0Dh, 0Ah,"Spinach has been restocked", 0Dh, 0Ah, "$"


    sold_milk db 0Dh, 0Ah,"Milk has been sold", 0Dh, 0Ah, "$"
    sold_Bread db 0Dh, 0Ah,"Bread has been sold", 0Dh, 0Ah, "$"
    sold_Eggs db 0Dh, 0Ah,"Eggs has been sold", 0Dh, 0Ah, "$"
    sold_Apples db 0Dh, 0Ah,"Apples has been sold", 0Dh, 0Ah, "$"
    sold_Spinach db 0Dh, 0Ah,"Spinach has been sold", 0Dh, 0Ah, "$"


    msg4 db "Item ID, Quantity", 0Dh, 0Ah, "$"


    quantities db 2, 3, 0, 5, 7
    dvd_count equ 5

    newline db 0Dh, 0Ah, '$' 

    dvd db '1','2','3','4','5'
    msg3 db  0Dh, 0Ah, "Item ID, Name, Quantity", 0Dh, 0Ah
    main_inventory2 db 0Dh, 0Ah, "1. Milk, 2", 0Dh, 0Ah
                   db "2. Bread, 3", 0Dh, 0Ah
                   db "3. Eggs, 0", 0Dh, 0Ah
                   db "4. Apples, 5", 0Dh, 0Ah
                   db "5. Spinach, 7", 0Dh, 0Ah, "$"
    msg2 db 0Dh, 0Ah,"Enter the item to sell (1-Milk, 2-Bread, 3-Eggs, 4-Apples, 5-Spinach, 6-Exit): $"
    quantity_msg2 db 0Dh, 0Ah, "Enter quantity to sell: $"
    updated_list2 db 0Dh, 0Ah, "Updated list of groceries:", 0Dh, 0Ah, '$'

    message db 0Dh, 0Ah, "Items with less than 3 in stock:", 0Dh, 0Ah, "$"
    product_names db "Milk", 0Dh, 0Ah
              db "Bread", 0Dh, 0Ah
              db "Eggs", 0Dh, 0Ah
              db "Apples", 0Dh, 0Ah
              db "Spinach", 0Dh, 0Ah, "$"
    

    msg db 0Dh, 0Ah,"Enter the item to restock (1-Milk, 2-Bread, 3-Eggs, 4-Apples, 5-Spinach, 6-Exit): $"


    quantity_msg db 0Dh, 0Ah, "Enter quantity to add: $"
    updated_list db 0Dh, 0Ah, "Updated list of groceries:", 0Dh, 0Ah, '$'
    finished_list db 0Dh, 0Ah, "Finished items:", 0Dh, 0Ah, '$'


    ; Storage for user input and updates
    item db 0
    quantity db 0

.code
main proc
    mov ax, @data
    mov ds, ax

display_menu:
    ; Display main menu
    mov ah, 09h
    mov dx, offset mainMenu
    int 21h

    ; Prompt user for input
    mov ah, 01h  ; Function to read a character from standard input
    int 21h      ; Invoke DOS interrupt

    ; Check the input character
    cmp al, '1'  ; Compare with ASCII character '1'
    je viewInventory
    cmp al, '2'  ; Compare with ASCII character '2'
    je sellItem
    cmp al, '3'  ; Compare with ASCII character '3'
    je restockItem
    cmp al, '4'  ; Compare with ASCII character '4'
    je exitProgram

    ; Invalid input, display error message and loop back to main menu
    jmp display_menu

restockItem:
    jmp do_restocking

sellItem:
    jmp do_selling

exitProgram:
    ; Exit the program
    mov ah, 4Ch
    int 21h



viewInventory:

;displaying all the items

    lea dx, msg3
    mov ah, 09h
    int 21h
  

;display items in shortage (need to order)
    
    lea dx, message
    mov ah, 09h
    int 21h

    lea dx, msg4
    mov ah, 09h
    int 21h

    ; Initialize index register
    mov si, 0

loop_start:
    ; Check if the index exceeds the count of items (5 items)
    cmp si, dvd_count
    jge finished_items ; If all items are checked, return to the main menu

    ; Check if the quantity is less than 3
    mov al, [quantities + si]
    cmp al, 3
    jge next_iteration  ; If greater than or equal to 3, skip printing
 
    ; Print the item ID
    mov dl, [dvd + si]
    mov ah, 02h         ; Function to print character
    int 21h

    ; Print a comma and space
    mov dl, ','
    int 21h
    mov dl, ' '
    int 21h

    ; Print the quantity
    mov al, [quantities + si]
    add al, '0'  ; Convert quantity to ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    ; Print newline
    lea dx, newline
    mov ah, 09h
    int 21h

next_iteration:
    ; Increment index and loop
    inc si
    jmp loop_start


finished_items:
; Display finished items
    lea dx, finished_list
    mov ah, 09h
    int 21h

    lea dx, msg4
    mov ah, 09h
    int 21h

    ; Initialize index register
    mov si, 0

loop_start2:
    ; Check if the index exceeds the count of items (5 items)
    cmp si, dvd_count
    jge done_display  ; If all items are checked, return to the main menu

    ; Check if the quantity is less than 3
    mov al, [quantities + si]
    cmp al, 0
    je print_item  ; If quantity is 0, print the item

    ; If the quantity is not 0, skip printing
    jmp next_iteration2

    ; Print the item ID
    print_item:
    mov dl, [dvd + si]
    mov ah, 02h         ; Function to print character
    int 21h

    ; Print a comma and space
    mov dl, ','
    int 21h
    mov dl, ' '
    int 21h

    ; Print the quantity
    mov al, [quantities + si]
    add al, '0'  ; Convert quantity to ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    ; Print newline
    lea dx, newline
    mov ah, 09h
    int 21h

next_iteration2:
    ; Increment index and loop
    inc si
    jmp loop_start2


done_display:
    jmp display_menu
    

    

do_selling:
    ; Code to sell item goes here
    sell_loop:
    ; Prompt user for item to sell
    mov ah, 09h
    lea dx, msg2
    int 21h

    ; Read user input for item
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to integer
    mov item, al

    ; Check if user wants to exit
    cmp item, 6
    je exitProgram2

    ; Prompt user for quantity to sell
    mov ah, 09h
    lea dx, quantity_msg2
    int 21h

    ; Read user input for quantity
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to integer
    mov quantity, al

    ; Update the quantity based on the selected item
    cmp item, 1
    je sell_milk
    cmp item, 2
    je sell_bread
    cmp item, 3
    je sell_eggs
    cmp item, 4
    je sell_apples
    cmp item, 5
    je sell_spinach
    jmp display_menu

exitProgram2:
    ; Exit the program
    jmp display_menu

sell_milk:
    ; Update milk quantity
    mov al, [quantities]  ; Load current milk quantity
    sub al, quantity      ; Subtract the sold quantity
    mov [quantities], al  ; Store the updated quantity
    ; Update milk quantity in main_inventory2
    mov al, [main_inventory2 + 11]  ; Load current milk quantity in main_inventory2
    sub al, quantity              ; Subtract the sold quantity
    mov [main_inventory2 + 11], al ; Store the updated quantity in main_inventory2

    lea dx, sold_milk
    mov ah, 09h
    int 21h

    jmp sell_loop               ; Jump back to the sell loop

sell_bread:
    ; Update bread quantity
    mov al, [quantities + 1]  ; Load current bread quantity
    sub al, quantity          ; Subtract the sold quantity
    mov [quantities + 1], al  ; Store the updated quantity
    ; Update bread quantity in main_inventory2
    mov al, [main_inventory2 + 24]  ; Load current bread quantity in main_inventory2
    sub al, quantity               ; Subtract the sold quantity
    mov [main_inventory2 + 24], al ; Store the updated quantity in main_inventory2

    lea dx, sold_Bread
    mov ah, 09h
    int 21h

    jmp sell_loop                  ; Jump back to the sell loop

sell_eggs:
    ; Update eggs quantity
    mov al, [quantities + 2]  ; Load current eggs quantity
    sub al, quantity          ; Subtract the sold quantity
    mov [quantities + 2], al  ; Store the updated quantity
    ; Update eggs quantity in main_inventory2
    mov al, [main_inventory2 + 36]  ; Load current eggs quantity in main_inventory2
    sub al, quantity                ; Subtract the sold quantity
    mov [main_inventory2 + 36], al ; Store the updated quantity in main_inventory2

    lea dx, sold_Eggs
    mov ah, 09h
    int 21h

    jmp sell_loop                  ; Jump back to the sell loop

sell_apples:
    ; Update apples quantity
    mov al, [quantities + 3]  ; Load current apples quantity
    sub al, quantity          ; Subtract the sold quantity
    mov [quantities + 3], al  ; Store the updated quantity
    ; Update apples quantity in main_inventory2
    mov al, [main_inventory2 + 50]  ; Load current apples quantity in main_inventory2
    sub al, quantity                ; Subtract the sold quantity
    mov [main_inventory2 + 50], al ; Store the updated quantity in main_inventory2

    lea dx, sold_Apples
    mov ah, 09h
    int 21h

    jmp sell_loop                  ; Jump back to the sell loop

sell_spinach:
    ; Update spinach quantity
    mov al, [quantities + 4]  ; Load current spinach quantity
    sub al, quantity          ; Subtract the sold quantity
    mov [quantities + 4], al  ; Store the updated quantity
    ; Update spinach quantity in main_inventory2
    mov al, [main_inventory2 + 65]  ; Load current spinach quantity in main_inventory2
    sub al, quantity                ; Subtract the sold quantity
    mov [main_inventory2 + 65], al ; Store the updated quantity in main_inventory2

    lea dx, sold_Spinach
    mov ah, 09h
    int 21h

    jmp sell_loop                  ; Jump back to the sell loop

jmp display_menu



do_restocking:   
    restock_loop:
    ; Prompt user for item to restock
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Read user input for item
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to integer
    mov item, al

    ; Check if user wants to exit
    cmp item, 6
    je end_display


    ; Prompt user for quantity to add
    mov ah, 09h
    lea dx, quantity_msg
    int 21h

    ; Read user input for quantity
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to integer
    mov quantity, al

    
    ; Update the quantity based on the selected item
    cmp item, 1
    je update_milk
    cmp item, 2
    je update_bread
    cmp item, 3
    je update_eggs
    cmp item, 4
    je update_apples
    cmp item, 5
    je update_spinach
    jmp display_menu

end_display:
    jmp display_menu

update_milk:
    ; Update milk quantity
    mov al, [quantities]      
    add al, quantity          
    mov [quantities], al 

    mov al, [main_inventory2 + 11]
    sub al, '0'
    add al, quantity
    add al, '0'
    mov [main_inventory2 + 11], al

    lea dx, restock_milk
    mov ah, 09h
    int 21h

    jmp restock_loop

update_spinach:
    jmp update_spinach2

update_bread:
    ; Update bread quantity
    mov al, [quantities + 1]      
    add al, quantity          
    mov [quantities + 1], al 

    mov al, [main_inventory2 + 24]
    sub al, '0'
    add al, quantity
    add al, '0'
    mov [main_inventory2 + 24], al

    lea dx, restock_Bread
    mov ah, 09h
    int 21h

    jmp restock_loop

update_eggs:
    ; Update eggs quantity
    mov al, [quantities + 2]      
    add al, quantity          
    mov [quantities + 2], al 

    mov al, [main_inventory2 + 36]
    sub al, '0'
    add al, quantity
    add al, '0'
    mov [main_inventory2 + 36], al

    lea dx, restock_Eggs
    mov ah, 09h
    int 21h

    jmp restock_loop

update_apples:
    ; Update apples quantity
    mov al, [quantities + 3]      
    add al, quantity          
    mov [quantities + 3], al 

    mov al, [main_inventory2 + 50]
    sub al, '0'
    add al, quantity
    add al, '0'
    mov [main_inventory2 + 50], al

    lea dx, restock_Apples
    mov ah, 09h
    int 21h

    jmp restock_loop

update_spinach2:
    ; Update spinach quantity
    mov al, [quantities + 4]      
    add al, quantity          
    mov [quantities + 4], al 

    mov al, [main_inventory2 + 65]
    sub al, '0'
    add al, quantity
    add al, '0'
    mov [main_inventory2 + 65], al

    lea dx, restock_Spinach
    mov ah, 09h
    int 21h

    jmp restock_loop


space db " ", 0Dh, 0Ah, "$"

main endp

end main
