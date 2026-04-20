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
    // Polynomial Memory Subsystem Parameters/Enums
    // =====================================================
    parameter int NUM_POLYS                         = 16;
    parameter int POLY_ID_WIDTH                     = $clog2(NUM_POLYS);

    // =====================================================
    // Transcoder Unit Parameters/Enums
    // =====================================================
    typedef enum logic [4:0] {
        // === High-Level Artifact Opcodes ===
        // --- KEYGEN ---
        TR_OP_KG_INGEST_D      = 5'd0,  // (AXI-RX -> SeedBank(d))
        TR_OP_KG_EXPORT_DK_PKE = 5'd1,  // (PolyMem(s) -> Encode12 -> AXI-TX)
        TR_OP_KG_EXPORT_EK_PKE = 5'd2,  // (PolyMem(t) -> Encode12 -> AXI-TX/HSU, SeedBank(rho) -> AXI-TX)
        TR_OP_KG_EXPORT_HEK    = 5'd3,  // (HSU(H(ek)) -> AXI-TX), SeedBank(rho) -> HSU (transcoder not responsible for this)

        // --- ENCAP ---
        TR_OP_EN_INGEST_M      = 5'd4,  // (AXI-RX -> SeedBank(m))
        TR_OP_EN_INGEST_EK     = 5'd5,  // (AXI-RX(ek:encoded(t-hat), rho) -> Decode(t-hat)/HSU(ek) -> PolyMem(t), extract Seed(rho) -> seedbank)
        TR_OP_EN_MSG_DEC       = 5'd6,  // (SeedBank(m) -> Decode_1 -> Decompress_1 -> PolyMem(mu))
        TR_OP_EN_EXPORT_CT_1   = 5'd7,  // (PolyMem(u) -> Compress_DU -> Encode_DU -> AXI-TX)
        TR_OP_EN_EXPORT_CT_2   = 5'd8,  // (PolyMem(v) -> Compress_DV -> Encode_DV -> AXI-TX)
        TR_OP_EN_EXPORT_K      = 5'd9,  // (Seedbank(k) -> AXI-TX)

        // --- DECAP ---
        TR_OP_DC_INGEST_DK_PKE = 5'd10, // (AXI-RX -> Decode12 -> PolyMem(s))
        TR_OP_DC_INGEST_C1     = 5'd11, // (AXI-RX -> Decode_DU -> Decompress_DU -> PolyMem(u'))
        TR_OP_DC_INGEST_C2     = 5'd12, // (AXI-RX -> Decode_DV -> Decompress_DV -> PolyMem(v'))
        TR_OP_DC_INGEST_Z      = 5'd13, // (AXI-RX -> SeedBank(z))
        TR_OP_DC_MSG_ENC       = 5'd14, // (PolyMem(w) -> Compress_1 -> Encode_1 -> Seedbank(m'))
        TR_OP_DC_EXPORT_K      = 5'd15, // (Seedbank(k) -> AXI-TX)
        TR_OP_DC_EXPORT_K_BAR  = 5'd16, // (Seedbank(k-bar) -> AXI-TX)
        TR_OP_DC_EXPORT_R      = 5'd17  // (Seedbank(r) -> AXI-TX)
    } tr_opcode_t;

endpackage
