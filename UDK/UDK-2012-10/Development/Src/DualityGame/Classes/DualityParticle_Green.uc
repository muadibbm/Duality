class DualityParticle_Green extends DualityInventoryItem;

function bool DenyPickupQuery(Class<Inventory> itemClass, Actor pickup) {
  return false;
}
