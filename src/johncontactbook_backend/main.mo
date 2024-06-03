import List "mo:base/List";


actor ContactBook {

  var contactDatabase = List.nil<Contact>();

  type Contact = {
    id : Nat;
    name : Text;
    phone : Text;
    email : Text;
    address : Text;
    group : Group;
  };

  type Group = {
    #Family;
    #Friends;
    #Work;
    #Other;
  };

  public query func getAllContacts() : async List.List<Contact> {
    return contactDatabase;
  };

  public query func getContactsByGroup(group : Group) : async List.List<Contact> {
    let matchedContacts = List.filter<Contact>(
      contactDatabase,
      func contact {
        contact.group == group;
      },
    );

    return matchedContacts;
  };

  public query func getNumberOfContacts() : async Nat {
    return List.size<Contact>(contactDatabase);
  };

  type ContactOperationResult = {
    #Success : Contact;
    #Failure : Text;
  };

  public query func getContact(id : Nat) : async ContactOperationResult {
    let matchedContact = List.find<Contact>(
      contactDatabase,
      func contact {
        contact.id == id;
      },
    );

    switch (matchedContact) {
      case (null) {
        return #Failure "Could not find any contact with the given ID";
      };
      case (?matchedContact) {
        return #Success matchedContact;
      };
    };
  };

  public func batchAddContacts(newContactList : List.List<Contact>) : async Text {
    let newList = List.append<Contact>(contactDatabase, newContactList);
    contactDatabase := newList;
    return "Successfully batch added contacts";
  };

  public func addNewContact(contact : Contact) : async Text {
    let newList = List.push<Contact>(contact, contactDatabase);
    contactDatabase := newList;
    return "Successfully added contact " # contact.name;
  };

  public func deleteContact(id : Nat) : async Text {
    let newDatabase = List.filter<Contact>(
      contactDatabase,
      func contact { contact.id != id },
    );
    if (List.size<Contact>(contactDatabase) == List.size<Contact>(newDatabase)) {
      return "No contact found with the given ID";
    } else {
      contactDatabase := newDatabase;
      return "Successfully deleted contact";
    };
  };
};
