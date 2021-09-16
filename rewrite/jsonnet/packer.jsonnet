local Export = import 'lib/export.jsonnet';

local proxmoxBuilder = {
  type: 'proxmox-clone',
  proxmox_url: 'https://farm.local:8006/api2/json',

};

local Packer = {
  export():: Export.asJsonDoc(self),
  builders: [proxmoxBuilder],
};

Packer
