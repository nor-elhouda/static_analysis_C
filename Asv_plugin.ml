
let help_msg = "Verification of standards compliance"

module Self = Plugin.Register
    (struct
      let name = "ASV"
      let shortname = "asv"
      let help = "verification of standards compliance"
    end)

module Enabled = Self.True
(struct
let option_name = "-asv"
let help = "when on (off by default), " ^ help_msg
end)







