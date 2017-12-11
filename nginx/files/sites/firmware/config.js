var config = {
  // list images on console that match no model
  listMissingImages: false,
  // see devices.js for different vendor model maps
  vendormodels: vendormodels,
  // community prefix of the firmware images
  community_prefix: 'gluon-ffka-',
  // relative image paths and branch
  directories: {
    // some demo sources
    './images/stable/factory/': 'stable',
    './images/stable/sysupgrade/': 'stable',
    './images/beta/factory/': 'beta',
    './images/beta/sysupgrade/': 'beta',
    './images/experimental/factory/': 'experimental',
    './images/experimental/sysupgrade/': 'experimental'
  }
};