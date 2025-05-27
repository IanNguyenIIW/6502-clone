
module core (
    input logic i_clk,
    input logic i_rst,
     
    inout logic [7:0] io_data,
    output logic [15:0] o_Addr,//Address pin
    output logic [2:0] o_out, //output pins used by controllers
    output logic read_write //HIGH cpu reads bus | LOW cpu writes to bus
      
);

    


    /*CPU REGISTERS*/
    reg [7:0] Accumulator;
    reg [7:0] Instruction_reg;

    //Index registers
    reg [7:0] X_reg;
    reg [7:0] Y_reg;

    reg [15:0] PC; //program counter pair of 8 bit registers
    reg [7:0] Stack_pt; //stack pointer

    //status register
    //NV1B DIZC (status's)
    reg [7:0] Status_reg; 




    

    typedef enum logic [2:0] { //typedef creates a name data type
    //enum declares a enumuerated type
    //logic data type
    //[2:0] is width of the 
        FETCH,
        DECODE,
        EXECUTE,
        MEM_READ,
        MEM_WRITE
    } state_t;


    state_t state, next_state;
    always_comb begin
            case(state)
                FETCH:    begin 
                    o_Addr = PC;
                    read_write = 1; //read from bus
                    next_state = DECODE;

                end


                DECODE:   begin 
                    Instruction_reg = io_data;
                    do_decode();
                    

                end
                EXECUTE:  next_state = MEM_READ;
                MEM_READ: next_state = MEM_WRITE;
                MEM_WRITE:next_state = FETCH;
        endcase
    end

    always_ff @(posedge i_clk or posedge i_rst) begin
        if(i_rst)begin
            state <= FETCH;
            Accumulator = 0;

            X_reg = 0;
            Y_reg = 0;
            PC = 16'hFFFC;
            Stack_pt = 8'hFD;
            Status_reg = 8'b0010_0100 ; 
            /*
            N= 0
            V=0
            D = 0
            I=1
            Z=0
            C=0
            */
        end
        else 
            state <= next_state;
    end


   always_ff @(posedge i_clk) begin
    if (state == FETCH) begin
        Instruction_reg <= io_data;
        PC <= PC + 1;
    end
    else if (state == DECODE) begin
        
    end
    else if (state == EXECUTE) begin



        
        Accumulator <= alu_result;
        Status_reg[0] <= alu_carry_out;
        Status_reg[1] <= alu_zero;
        Status_reg[7] <= alu_negative;
        Status_reg[6] <= alu_overflow;
    end
    else if (state == MEM_READ) begin

    end
    else if (state == MEM_WRITE) begin

    end
end
    

    logic [7:0] alu_a, alu_b, alu_result;
    logic alu_carry_in, alu_carry_out, alu_overflow, alu_zero, alu_negative;
    logic [3:0] ALUControl; // from decode

    assign alu_a = Accumulator;
    assign alu_b = /* operand from memory */;
    assign alu_carry_in = Status_reg[0];


    alu alu1(
        .control(ALUControl),
        .a(alu_a),
        .b(alu_b),
        .cin(alu_carry_in),
        .result(alu_result),
        .cout(alu_carry_out),
        .overflow(alu_overflow),
        .zero(alu_zero),
        .negative(alu_negative)
    );
    typedef enum logic[7:0]{
        //LDA
        LDA_imm = 8'hA9; //this
        LDA_zp = 8'hA5; 
        LDA_zpx = 8'hB5;
        LDA_abs = 8'hAD; //this
        LDA_abx = 8'hBD;


    } operations;



    task do_decode();
        case(Instruction_reg)
            LDA_imm: begin
                ALUControl = PASS;


                next_state = EXECUTE;
            end


        endcase

    endtask
endmodule
