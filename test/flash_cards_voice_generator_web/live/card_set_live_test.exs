defmodule FlashCardsVoiceGeneratorWeb.CardSetLiveTest do
  use FlashCardsVoiceGeneratorWeb.ConnCase

  import Phoenix.LiveViewTest
  import FlashCardsVoiceGenerator.CardSetsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_card_set(_) do
    card_set = card_set_fixture()
    %{card_set: card_set}
  end

  describe "Index" do
    setup [:create_card_set]

    test "lists all card_sets", %{conn: conn, card_set: card_set} do
      {:ok, _index_live, html} = live(conn, ~p"/card_sets")

      assert html =~ "Listing Card sets"
      assert html =~ card_set.name
    end

    test "saves new card_set", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/card_sets")

      assert index_live |> element("a", "New Card set") |> render_click() =~
               "New Card set"

      assert_patch(index_live, ~p"/card_sets/new")

      assert index_live
             |> form("#card_set-form", card_set: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#card_set-form", card_set: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/card_sets")

      html = render(index_live)
      assert html =~ "Card set created successfully"
      assert html =~ "some name"
    end

    test "updates card_set in listing", %{conn: conn, card_set: card_set} do
      {:ok, index_live, _html} = live(conn, ~p"/card_sets")

      assert index_live |> element("#card_sets-#{card_set.id} a", "Edit") |> render_click() =~
               "Edit Card set"

      assert_patch(index_live, ~p"/card_sets/#{card_set}/edit")

      assert index_live
             |> form("#card_set-form", card_set: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#card_set-form", card_set: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/card_sets")

      html = render(index_live)
      assert html =~ "Card set updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes card_set in listing", %{conn: conn, card_set: card_set} do
      {:ok, index_live, _html} = live(conn, ~p"/card_sets")

      assert index_live |> element("#card_sets-#{card_set.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#card_sets-#{card_set.id}")
    end
  end

  describe "Show" do
    setup [:create_card_set]

    test "displays card_set", %{conn: conn, card_set: card_set} do
      {:ok, _show_live, html} = live(conn, ~p"/card_sets/#{card_set}")

      assert html =~ "Show Card set"
      assert html =~ card_set.name
    end

    test "updates card_set within modal", %{conn: conn, card_set: card_set} do
      {:ok, show_live, _html} = live(conn, ~p"/card_sets/#{card_set}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Card set"

      assert_patch(show_live, ~p"/card_sets/#{card_set}/show/edit")

      assert show_live
             |> form("#card_set-form", card_set: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#card_set-form", card_set: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/card_sets/#{card_set}")

      html = render(show_live)
      assert html =~ "Card set updated successfully"
      assert html =~ "some updated name"
    end
  end
end
