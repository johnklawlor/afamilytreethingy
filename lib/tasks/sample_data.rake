namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		[Member, Relationship].each(&:delete_all)

		lucy=Member.create!(first_name: "Lucy", last_name: "Lawlor", email: "lucy@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: 5, birthdate: Date.new(1952,9,7), full_account: true, state: 1)
		jack=Member.create!(first_name: "Jack", last_name: "Lawlor", email: "jack@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: lucy.id, birthdate: Date.new(1951,11,19), full_account: true, state: 1)
		jack.oldest_ancestor = jack.id
		jack.save
		lucy.oldest_ancestor = lucy.id
		lucy.save

		daniel=Member.create!(first_name: "Daniel", last_name: "Lawlor", email: "daniel@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: 6, oldest_ancestor: lucy.id, birthdate: Date.new(1983,1,11), full_account: true, state: 1)
		daniel.oldest_ancestor = lucy.id
		daniel.save
		michelle=Member.create!(first_name: "Michelle", last_name: "Lawlor", email: "Michelle@lawlor.com", password: "foobar", password_confirmation: "foobar", oldest_ancestor: lucy.id, birthdate: Date.new(1988,12,12), full_account: true, state: 1)
		michelle.oldest_ancestor = lucy.id
		michelle.save
		kara=Member.create!(first_name: "Kara", last_name: "Lawlor", email: "kara@lawlor.com", password: "foobar", password_confirmation: "foobar", spouse_id: daniel.id, birthdate: Date.new(1983,1,3), full_account: true, state: 1)
		kara.oldest_ancestor = kara.id
		kara.save
		kieran=Member.create!(first_name: "Kieran", last_name: "Lawlor", email: "kieran@lawlor.com", password: "foobar", password_confirmation: "foobar", oldest_ancestor: lucy.id, birthdate: Date.new(2013,05,26), full_account: true, state: 1)
		kieran.oldest_ancestor = lucy.id
		kieran.save
		john=Member.create!(first_name: "John", last_name: "Lawlor", email: "john.k.lawlor@gmail.com", password: "foobar", password_confirmation: "foobar", oldest_ancestor: lucy.id, birthdate: Date.new(1987,5,21), full_account: true, state: 1)
		john.oldest_ancestor = lucy.id
		john.save

		john.reverse_relationships.create!(parent_id: lucy.id)
		john.reverse_relationships.create!(parent_id: jack.id)


		daniel.reverse_relationships.create!(parent_id: lucy.id)
		daniel.reverse_relationships.create!(parent_id: jack.id)

		michelle.reverse_relationships.create!(parent_id: lucy.id)
		michelle.reverse_relationships.create!(parent_id: jack.id)

		kieran.reverse_relationships.create!(parent_id: kara.id)
		kieran.reverse_relationships.create!(parent_id: daniel.id)
		
		lucy.spouse_relationships.create!(spouse_id: jack.id)
		jack.spouse_relationships.create!(spouse_id: lucy.id)
		kara.spouse_relationships.create!(spouse_id: daniel.id)
		daniel.spouse_relationships.create!(spouse_id: kara.id)
	end
end