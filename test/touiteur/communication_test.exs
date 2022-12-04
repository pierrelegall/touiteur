defmodule Touiteur.CommunicationTest do
  use Touiteur.DataCase

  alias Touiteur.Communication

  describe "messages" do
    alias Touiteur.Communication.Message

    import Touiteur.CommunicationFixtures
    alias Touiteur.AccountsFixtures

    @invalid_attrs %{content: nil}

    # WARN: found a solution to avoid the use of :timer.sleep/1
    test "list_messages/0 returns all messages ordered my inserted_at" do
      message1 = message_fixture()
      assert Communication.list_messages() == [message1]

      :timer.sleep(1000)

      message2 = message_fixture()
      assert Communication.list_messages() == [message2, message1]

      :timer.sleep(1000)

      message3 = message_fixture()
      assert Communication.list_messages() == [message3, message2, message1]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Communication.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      %{id: author_id} = AccountsFixtures.user_fixture()
      valid_attrs = %{content: "some content", author_id: author_id}

      assert {:ok, %Message{} = message} = Communication.create_message(valid_attrs)
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communication.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Message{} = message} = Communication.update_message(message, update_attrs)
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Communication.update_message(message, @invalid_attrs)
      assert message == Communication.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Communication.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Communication.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Communication.change_message(message)
    end
  end
end
