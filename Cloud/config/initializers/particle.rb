Particle.configure do |c|
  c.access_token = Figaro.env.particle_token
end
