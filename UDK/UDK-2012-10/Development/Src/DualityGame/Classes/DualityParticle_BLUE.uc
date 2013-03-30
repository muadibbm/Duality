class DualityParticle_BLUE extends DualityInventoryItem;

function bool DenyPickupQuery(Class<Inventory> itemClass, Actor pickup) {
  return false;
}
