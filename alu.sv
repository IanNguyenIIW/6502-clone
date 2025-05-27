
//NOTE cin and cout are from the same status register, however cout is the value after cin. after a instruction is done. an instruction uses the previous carry, and then updates the carry
//NEED ADD, SUB, AND, ORA, EOR, XOR, 
module alu (

    input logic [3:0] control,
    input logic [7:0] a,
    input logic [7:0] b,
    input logic cin,

    output logic [7:0] result,
    output logic cout,
    output logic overflow,
    output logic zero,
    output logic negative

);  

    reg [7:0] result;

    typedef enum logic [3:0] { 
        ADC,
        SBC,
        AND,
        ORA,
        EOR,
        ASL,
        LSR,
        ROL,
        ROR,
        CMP,
        PASS
    } operation_t operation;
    logic [8:0] temp;
    always_comb begin
        temp = 9'b0;
        cout = 0;
        overflow = 0; 
        result = 8'd0;


        case(control)
        ADC: begin
            temp = a + b + cin; 
            cout = temp[8];
            result = temp[7:0]
            overflow = (~a[7] ^ b[7]) & (a[7] ^ result[7]);

        end
        SBC: begin
            temp = a - b - (~cin);  // carry in is NOT borrow
            result = temp[7:0];
            cout = ~temp[8];        // carry clear means borrow
            overflow = ((~b[7] ^ esult[7]) & (a[7] ^ result[7])); // from NESdev
        end
        AND: result = a & b;
        ORA: result = a | b;
        EOR: result = a ^ b;
        ASL: begin
            result = a << 1;
            cout = a[7];
        end
        LSR: begin
            result = a >> 1;
            cout = a[0];
        end
        ROL:begin
            result = (a << 1) | cin;
            cout = a[7];
        end
        ROR:begin
            result = (a >> 1) | (cin<<7);
            cout = a[0];
        end
        CMP:begin
            temp = a - b;
            result = temp[7:0];
            cout = ~temp[8];
        end
        PASS: result = a;


        endcase
        zero = (result == 8'b0);
        negative = result[7];

    end



endmodule