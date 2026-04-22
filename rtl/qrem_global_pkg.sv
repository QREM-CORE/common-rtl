/*
 * Module Name: qrem_global_pkg
 * Author(s):   Kiet Le
 * Description: Global package for QREM.
 */

package qrem_global_pkg;

    // =====================================================
    // General Parameters
    // =====================================================

    // Standard Bus Size
    parameter int DWIDTH                            = 64;
    parameter int LOG_DWIDTH                        = $clog2(DWIDTH);

    // Polynomial Parameters
    parameter int COEFF_WIDTH                       = 12;
    parameter int NCOEFF                            = 256;
    parameter int Q                                 = 3329;

    // Polynomial Memory Subsystem Parameters
    parameter int NUM_POLYS                         = 32;
    parameter int POLY_ID_WIDTH                     = $clog2(NUM_POLYS);

    // Seed Memory Parameters
    parameter int SEED_DEPTH                        = 32;
    parameter int SEED_W                            = 64;
    parameter int SEED_BEATS                        = 4; // 256-bit objects

    // =====================================================
    // Global Memory Arbitration Enums
    // =====================================================

    typedef enum logic [2:0] {
        OWNER_NONE    = 3'd0,
        OWNER_PAU     = 3'd1,
        OWNER_PAU_AUX = 3'd2,
        OWNER_HSU     = 3'd3,
        OWNER_TR      = 3'd4
    } client_owner_e;

    typedef enum logic [1:0] {
        REQ_NONE  = 2'd0,
        REQ_READ  = 2'd1,
        REQ_WRITE = 2'd2
    } req_kind_e;

    // =====================================================
    // Seed / Protocol Storage Enums
    // =====================================================

    typedef enum logic [2:0] {
        SEED_ID_D     = 3'd0,
        SEED_ID_Z     = 3'd1,
        SEED_ID_M     = 3'd2,
        SEED_ID_RHO   = 3'd3,
        SEED_ID_SIGMA = 3'd4,
        SEED_ID_HEK   = 3'd5,
        SEED_ID_SS    = 3'd6,
        SEED_ID_TMP   = 3'd7
    } seed_id_e;

    // =====================================================
    // Core Control Unit Parameters/Enums
    // =====================================================


    // =====================================================
    // Hash Sampler Unit Parameters/Enums
    // =====================================================
    typedef enum logic [2:0] {
        MODE_SAMPLE_NTT    = 3'd0, // Op: SHAKE128  | Sampler: Rejection | Target: Matrix A
        MODE_SAMPLE_CBD    = 3'd1, // Op: SHAKE256  | Sampler: CBD       | Target: s, e, e1, e2
        MODE_HASH_SHA3_256 = 3'd2, // Op: SHA3-256  | Sampler: Bypass    | Target: H(pk), H(m), H(c)
        MODE_HASH_SHA3_512 = 3'd3, // Op: SHA3-512  | Sampler: Bypass    | Target: G(d), G(m, h)
        MODE_HASH_SHAKE256 = 3'd4  // Op: SHAKE256  | Sampler: Bypass    | Target: J(z, c)
    } hs_mode_t;

    // =====================================================
    // Polynomial Arithmetic Unit Parameters/Enums
    // =====================================================


    // =====================================================
    // Transcoder Unit Parameters/Enums
    // =====================================================
    typedef enum logic [4:0] {
        // === High-Level Artifact Opcodes ===
        TR_OP_IDLE                  = 5'd0,

        // --- KEYGEN ---
        TR_OP_KG_INGEST_D           = 5'd1,     // AXI-RX -> SeedBank(d)
        // Note: Not ingesting z because z is not used in KeyGen phase
        TR_OP_KG_EXPORT_DK_PKE      = 5'd2,     // PolyMem(s-hat) -> Encode12 -> AXI-TX
        TR_OP_KG_EXPORT_EK_PKE_1    = 5'd3,     // PolyMem(t) -> Encode12 -> AXI-TX
        TR_OP_KG_EXPORT_EK_PKE_2    = 5'd4,     // SeedBank(rho) -> AXI-TX
        TR_OP_KG_EXPORT_HEK         = 5'd5,     // SeedBank(H(ek)) -> AXI-TX
                                                // Note: core controller is responsible for creating H(ek)

        // --- ENCAP ---
        TR_OP_EN_INGEST_M           = 5'd6,     // AXI-RX -> SeedBank(m)
        TR_OP_EN_INGEST_EK_1        = 5'd7,     // AXI-RX(ek:t-hat) -> Decode_12(t-hat) -> PolyMem(t)
        TR_OP_EN_INGEST_EK_2        = 5'd8,     // AXI-RX(ek:rho) -> SeedBank(rho)
                                                // Note: core controller is responsible for creating H(ek)
        TR_OP_EN_MSG_DEC            = 5'd9,     // SeedBank(m) -> Decode_1/Decompress_1 -> PolyMem(mu)
        TR_OP_EN_EXPORT_CT_1        = 5'd10,    // PolyMem(u) -> Compress_DU/Encode_DU -> AXI-TX
        TR_OP_EN_EXPORT_CT_2        = 5'd11,    // PolyMem(v) -> Compress_DV/Encode_DV -> AXI-TX
        TR_OP_EN_EXPORT_K           = 5'd12,    // Seedbank(k) -> AXI-TX

        // --- DECAP ---
        TR_OP_DC_INGEST_DK_PKE      = 5'd13,    // AXI-RX -> Decode12 -> PolyMem(s)
        TR_OP_DC_INGEST_C1          = 5'd14,    // AXI-RX -> HSU and Decode_DU/Decompress_DU -> PolyMem(u')
        TR_OP_DC_INGEST_C2          = 5'd15,    // AXI-RX -> HSU and Decode_DV/Decompress_DV -> PolyMem(v')
        TR_OP_DC_INGEST_Z           = 5'd16,    // AXI-RX -> SeedBank(z)
        TR_OP_DC_MSG_ENC            = 5'd17,    // PolyMem(w) -> Compress_1/Encode_1 -> Seedbank(m')
        TR_OP_DC_EXPORT_K           = 5'd18,    // Seedbank(k) -> AXI-TX
        TR_OP_DC_EXPORT_K_BAR       = 5'd19,    // Seedbank(k-bar) -> AXI-TX
        TR_OP_DC_EXPORT_R           = 5'd20     // Seedbank(r) -> AXI-TX
    } tr_opcode_t;

endpackage
