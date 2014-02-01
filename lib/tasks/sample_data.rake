namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		[Member, Relationship].each(&:delete_all)

		lucy=Member.create!(first_name: "Lucy", last_name: "Lawlor", email: "Lucy@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: 5, birthdate: Date.new(1952,9,7), full_account: true)
		jack=Member.create!(first_name: "Jack", last_name: "Lawlor", email: "jack@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: lucy.id, oldest_ancestor: lucy.id, birthdate: Date.new(1951,11,19), full_account: true)
		lucy.spouse_id = jack.id
		lucy.save
		john=Member.create!(first_name: "John", last_name: "Lawlor", email: "john@lawlor.com", password: "foobar", password_confirmation: "foobar", oldest_ancestor: lucy.id, birthdate: Date.new(1987,5,21), full_account: true)
		daniel=Member.create!(first_name: "Daniel", last_name: "Lawlor", email: "daniel@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: 6, oldest_ancestor: lucy.id, birthdate: Date.new(1983,1,11), full_account: true)
		michelle=Member.create!(first_name: "Michelle", last_name: "Lawlor", email: "Michelle@lawlor.com", password: "foobar", password_confirmation: "foobar", oldest_ancestor: lucy.id, birthdate: Date.new(1988,12,12), full_account: true)
		kara=Member.create!(first_name: "Kara", last_name: "Lawlor", email: "kara@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: daniel.id, oldest_ancestor: lucy.id, birthdate: Date.new(1983,1,3), full_account: true)
		daniel.spouse_id = kara.id
		daniel.save
		kieran=Member.create!(first_name: "Kieran", last_name: "Lawlor", email: "kieran@lawlor.com", password: "foobar", password_confirmation: "foobar", oldest_ancestor: lucy.id, birthdate: Date.new(2013,05,26), full_account: true)


		john.reverse_relationships.create!(parent_id: lucy.id)
		john.reverse_relationships.create!(parent_id: jack.id)

		daniel.reverse_relationships.create!(parent_id: lucy.id)
		daniel.reverse_relationships.create!(parent_id: jack.id)

		michelle.reverse_relationships.create!(parent_id: lucy.id)
		michelle.reverse_relationships.create!(parent_id: jack.id)

		kieran.reverse_relationships.create(parent_id: kara.id)
		kieran.reverse_relationships.create(parent_id: daniel.id)
	end
end