RSpec.describe UserIdDGFIPService do
  let(:user_id) { 'my-user_id@ok.com' }

  it 'subtitutes -, _ and @ in user_id to fit in exotic dgfip params formatting rules' do
    reformatted_user_id = described_class.call(user_id)
    expect(reformatted_user_id).to eq('my_user_id_at_ok_com')
  end
end
