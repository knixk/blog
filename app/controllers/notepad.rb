event = AmplitudeAPI::Event.new({
    user_id: current_user.id.to_s,
    event_type: event_name,
    time: Time.now.to_i * 1000, # Amplitude expects time in milliseconds
    insert_id: SecureRandom.uuid, # Generate a unique insert ID
    event_properties: {
      shark_id: shark.id,
      shark_name: shark.name,
      facts: shark.facts
    }
  })