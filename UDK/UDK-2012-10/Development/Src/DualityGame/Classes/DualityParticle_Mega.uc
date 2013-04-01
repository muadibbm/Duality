class DualityParticle_Mega extends DualityInventoryItem;

function bool DenyPickupQuery(Class<Inventory> itemClass, Actor pickup) {
  return false;
}