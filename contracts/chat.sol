// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract Twitter_BUNN{

    struct User{
        address wallet;
        string name;
        uint[] userTweets;
        address[] following;
        address[] followers;

        mapping(address => Message[]) convesations;
    }

    struct Message{
        uint messageId;
        string content;
        address from;
        address to;
    }

    struct Tweet{
        uint tweetId;
        address author;
        string content;
        uint createdAt;
    }

    mapping(address => User) public users;

    mapping(uint => Tweet ) public tweets;

    uint public nextTweetId;

    uint public nextMessageId;

    function registerAccount(string memory _name) external{
        bytes memory bname = bytes(_name);

        require(bname.length != 0, "Name cannot be an empty string");

        User storage newUser = users[msg.sender];
        newUser.wallet = msg.sender;
        newUser.name = _name;

    }

    modifier accountExist(address _user){
        User storage thisUser = users[_user];

        bytes memory thisUserBytestr = bytes(thisUser.name);

        require(thisUserBytestr.length != 0, " This wallet does not belong to anyone");
        _;
    }

    function postTweet(string memory _content) external accountExist(msg.sender){
        Tweet memory newTweet = Tweet(nextTweetId, msg.sender, _content, block.timestamp);

        tweets[nextTweetId]= newTweet;

        User storage thisUser = users[msg.sender];

        thisUser.userTweets.push(nextTweetId);
        nextTweetId+=1;
    }

function readTweet(address _user)view external returns (Tweet[] memory){
    uint[] storage userTweetIds = users[_user].userTweets;

    Tweet[] memory userTweets = new Tweet[](userTweetIds.length);

    for(uint i=0; i < userTweetIds.length; i++){
        userTweets[i] = tweets[userTweetIds[i]];
    }
    return userTweets;
}


function followUser(address _user) external accountExist(_user) accountExist(msg.sender){

    User storage functionCaller = users[msg.sender];
    functionCaller.following.push(_user);

    User storage user = users[_user];
    user.followers.push(msg.sender);
}

function getFollowing() external view accountExist(msg.sender) returns(address[] memory){
    return users[msg.sender].following;
}

function getFollowers() external view accountExist(msg.sender) returns (address []memory){
    return users[msg.sender].followers;
}

function sendMassage(address _recipient, string memory _content) external accountExist(msg.sender) accountExist(_recipient){
    Message memory newMessage = Message(nextMessageId, _content, msg.sender, _recipient );

    User storage sender = users[msg.sender];
    sender.convesations[_recipient].push(newMessage);
    
    User storage recipient = users[_recipient];
    recipient.convesations[msg.sender].push(newMessage);

    nextMessageId+=1;
}

function getConverstionWithUser(address _user)external view returns (Message[] memory){
    User storage thisUser = users[msg.sender];
    return thisUser.convesations[_user];
}

}