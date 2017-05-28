INSERT INTO `jobs` (name, label)
VALUES
  ('lumberjack', 'Bûcheron')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female)
VALUES
  ('lumberjack',0,'employee','',500,'{\"shoes\":12,\"helmet_1\":0,\"torso_1\":126,\"torso_2\":10,\"pants_1\":9,\"glasses_1\":0,\"pants_2\":7,\"arms\":16,\"helmet_2\":0,\"face\":19,\"decals_1\":0,\"skin\":34,\"glasses_2\":0,\"decals_2\":0,\"hair_2\":0,\"hair_1\":2,\"tshirt_1\":57,\"hair_color_2\":0,\"hair_color_1\":5,\"sex\":0,\"tshirt_2\":0}','{\"arms\":17,\"tshirt_1\":34,\"tshirt_2\":0,\"hair_color_2\":0,\"glasses\":0,\"torso_1\":121,\"helmet_1\":0,\"glasses_1\":5,\"skin\":13,\"glasses_2\":0,\"helmet_2\":0,\"sex\":1,\"hair_1\":2,\"pants_2\":0,\"decals_2\":0,\"pants_1\":30,\"decals_1\":0,\"torso_2\":12,\"face\":6,\"shoes\":2,\"hair_color_1\":0,\"hair_2\":0}')
;

INSERT INTO `items` (`name`, `label`)
VALUES
	('wood', 'Bois'),
	('cutted_wood', 'Bois coupé'),
	('packaged_plank', 'Paquet de planches')
;