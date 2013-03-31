class DualityParticle_Red extends DualityInventoryItem;

function bool DenyPickupQuery(Class<Inventory> itemClass, Actor pickup) {
  return false;
}