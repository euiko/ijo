class User {
	constructor(object) {
		this.id = object.id;
		this.username = object.username;
		this.password = object.password;
	}

	checkPassword(password) {
		return this.password === app.utils.crypto.hash(password);
	}
}

module.exports = class UserManager {
	constructor() {}

	create(username, password) {
		let id = app.utils.generate.shortid();

		return app.db.get("users").push({
			id, username, password
		}).write();
	}

	getUser(key, value) {
		var user = app.db.get("users").find(user => user[key] === value).value();

		if(user === undefined) {
			return undefined;
		}

		return new User(user);
	}
}