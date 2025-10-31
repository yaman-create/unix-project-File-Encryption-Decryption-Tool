#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Encryption/Decryption Logic (Same Function)
void xor_cipher_process(const char *inputFileName, const char *outputFileName, const char *key) {
    FILE *inputFile = fopen(inputFileName, "rb");
    if (inputFile == NULL) {
        perror("Error opening input file");
        return;
    }

    FILE *outputFile = fopen(outputFileName, "wb");
    if (outputFile == NULL) {
        perror("Error opening output file");
        fclose(inputFile);
        return;
    }

    int keyLength = strlen(key);
    int keyIndex = 0;
    int byte;

    // Read the file byte-by-byte until the End Of File (EOF)
    while ((byte = fgetc(inputFile)) != EOF) {
        // Apply XOR operation with the key character
        int processedByte = byte ^ key[keyIndex];
        fputc(processedByte, outputFile);
        // Move to the next key character (round-robin)
        keyIndex = (keyIndex + 1) % keyLength;
    }

    fclose(inputFile);
    fclose(outputFile);
    printf("\n--- Operation successful ---\n");
}

// Function to display description, menu, and handle user choices
void run_menu() {
    int choice;
    char inputFile[100];
    char outputFile[100];
    char password[100];

    // **********************************************
    // NEW ADDITION: Project Description
    // **********************************************
    printf("\n=======================================================\n");
    printf("              UNIX FILE CRYPTO UTILITY          \n");
    printf("=======================================================\n");
    printf("This is a menu-driven UNIX-based utility developed using\n");
    printf("the C programming language. Its primary function is to\n");
    printf("secure files through encryption and decryption using the\n");
    printf("simple yet effective 'XOR Cipher' algorithm. \n");
    printf("-------------------------------------------------------\n");
    
    while (1) { // Loop until the user selects 'Exit'
        printf("\n| M A I N   M E N U |\n");
        printf("---------------------\n");
        printf("1. Encrypt File\n");
        printf("2. Decrypt File\n");
        printf("3. Exit Program\n");
        printf("---------------------\n");
        printf("Enter your choice (1-3): ");

        // Read user input
        if (scanf("%d", &choice) != 1) {
            printf("\nInvalid input. Please enter a number.\n");
            // Clear input buffer (essential in C)
            while (getchar() != '\n');
            continue;
        }

        // Clear buffer after reading the number
        while (getchar() != '\n'); 

        switch (choice) {
            case 1:
                printf("\n--- ENCRYPTION MODE ---\n");
                printf("Enter input file name (e.g., secret.txt): ");
                scanf("%99s", inputFile);
                printf("Enter output file name (e.g., encrypted.enc): ");
                scanf("%99s", outputFile);
                printf("Enter Password/Key: ");
                scanf("%99s", password);
                xor_cipher_process(inputFile, outputFile, password);
                break;

            case 2:
                printf("\n--- DECRYPTION MODE ---\n");
                printf("Enter input (Encrypted) file name: ");
                scanf("%99s", inputFile);
                printf("Enter output (Decrypted) file name: ");
                printf("Enter Password/Key (MUST BE THE SAME as Encryption key): ");
                scanf("%99s", password);
                xor_cipher_process(inputFile, outputFile, password);
                break;

            case 3:
                printf("\nExiting the program. Goodbye!\n");
                return; // Exit the function, which ends the program

            default:
                printf("\nInvalid option. Please select 1, 2, or 3.\n");
                break;
        }
    }
}

int main() {
    // The main function only calls the menu handler
    run_menu();
    return 0;
}