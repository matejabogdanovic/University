.global _ZN7_thread13contextSwitchEPNS_7ContextES1_b
.type _ZN7_thread13contextSwitchEPNS_7ContextES1_b, @function
_ZN7_thread13contextSwitchEPNS_7ContextES1_b:
    # a0 is oldContext, a1 is newContext, a2 is bool true if should save old context

    andi a2, a2, 255 # if old thread deallocated branch and load only new context
    bnez a2, load_new_context   #_ZN7_thread13contextSwitchEPNS_7ContextES1_b

    sd ra, 0*8(a0)
    sd sp, 1*8(a0)

load_new_context:
    ld ra, 0*8(a1)
    ld sp, 1*8(a1)

    ret