class SinkListenerImpl implements SinkListener {
  void sinking(Particle p) {
    float proportionSunk = 1 / (p.radius * 2);
    Floor.update(proportionSunk);
  }  
}
