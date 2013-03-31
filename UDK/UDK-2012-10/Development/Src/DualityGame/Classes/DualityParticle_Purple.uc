class DualityParticle_Purple extends DualityInventoryItem;

function bool DenyPickupQuery(Class<Inventory> itemClass, Actor pickup) {
  return false;
}