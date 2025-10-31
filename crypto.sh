#!/bin/bash

# Function to perform XOR encryption/decryption
xor_cipher_process() {
    INPUT_FILE="$1"
    OUTPUT_FILE="$2"
    PASSWORD="$3"
    
    # Check if input file exists
    if [ ! -f "$INPUT_FILE" ]; then
        echo "Error: Input file '$INPUT_FILE' not found."
        return
    fi

    # Convert the file content to a hexadecimal string
    FILE_HEX=$(xxd -p "$INPUT_FILE" | tr -d '\n')
    FILE_LENGTH=${#FILE_HEX}
    
    # Convert password to hex and repeat it to match file length
    # Note: This is simplified XOR implementation for demonstration.
    KEY_HEX=$(echo -n "$PASSWORD" | xxd -p)
    KEY_LENGTH=${#KEY_HEX}
    
    PROCESSED_HEX=""
    
    for (( i=0; i<$FILE_LENGTH; i+=2 )); do
        # Get one byte (2 hex characters) from the file
        BYTE_HEX="${FILE_HEX:$i:2}"
        
        # Determine the key index (round-robin)
        KEY_INDEX=$(( (i / 2) % (KEY_LENGTH / 2) * 2 ))
        KEY_BYTE_HEX="${KEY_HEX:$KEY_INDEX:2}"
        
        # Convert hex to decimal
        BYTE_DEC=$(( 16#$BYTE_HEX ))
        KEY_DEC=$(( 16#$KEY_BYTE_HEX ))
        
        # Perform XOR operation
        XOR_DEC=$(( BYTE_DEC ^ KEY_DEC ))
        
        # Convert result back to hex (padding with zero if needed)
        XOR_HEX=$(printf "%02x" "$XOR_DEC")
        
        PROCESSED_HEX+="$XOR_HEX"
    done

    # Write the final hex string back to a file
    echo "$PROCESSED_HEX" | xxd -r -p > "$OUTPUT_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "\n--- Operation successful ---\n"
    else
        echo -e "\n--- Operation failed ---\n"
    fi
}

# Function to display description, menu, and handle user choices
run_menu() {
    # **********************************************
    # Project Description (Updated for Shell Script)
    # **********************************************
    echo -e "\n======================================================="
    echo "              UNIX FILE CRYPTO UTILITY          "
    echo "======================================================="
    echo "This is a menu-driven utility developed using the **Bash**"
    echo "Shell Scripting language. It secures files through "
    echo "encryption and decryption using the **XOR Cipher** logic."
    echo "It uses core UNIX commands like 'xxd' for processing."
    echo "-------------------------------------------------------"
    
    while true; do # Loop until the user selects 'Exit'
        echo -e "\n| M A I N   M E N U |"
        echo "---------------------"
        echo "1. Encrypt File"
        echo "2. Decrypt File"
        echo "3. Exit Program"
        echo "---------------------"
        read -p "Enter your choice (1-3): " choice

        case $choice in
            1)
                echo -e "\n--- ENCRYPTION MODE ---"
                read -p "Enter input file name (e.g., secret.txt): " inputFile
                read -p "Enter output file name (e.g., encrypted.enc): " outputFile
                read -p "Enter Password/Key: " password
                xor_cipher_process "$inputFile" "$outputFile" "$password"
                ;;

            2)
                echo -e "\n--- DECRYPTION MODE ---"
                read -p "Enter input (Encrypted) file name: " inputFile
                read -p "Enter output (Decrypted) file name: " outputFile
                read -p "Enter Password/Key (MUST BE THE SAME as Encryption key): " password
                xor_cipher_process "$inputFile" "$outputFile" "$password"
                ;;
                
            3)
                echo -e "\nExiting the program. Goodbye!\n"
                return # Exit the function, which ends the script
                ;;

            *)
                echo -e "\nInvalid option. Please select 1, 2, or 3.\n"
                ;;
        esac
    done
}

# Start the menu
run_menu