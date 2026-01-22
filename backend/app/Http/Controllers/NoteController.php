<?php

namespace App\Http\Controllers;

use App\Models\Note;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Http\Request;

class NoteController extends Controller
{
    use AuthorizesRequests;

    public function __construct()
    {
        $this->middleware('auth:sanctum');
        $this->authorizeResource(Note::class,'note');
    }
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $notes = $request->user()->notes()->latest()->paginate(15);
        return response()->json($notes);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
     public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|max:200',
            'note' => 'required'
        ]);

        $note = $request->user()->notes()->create($validated);

        return response()->json(['message'=>'Created successfully','note'=>$note],201);
    }

    /**
     * Display the specified resource.
     */
    public function show( Note $note)
    {
        return response()->json($note);
    }

    /**
     * Show the form for editing the specified resource.
     */
//    public function edit(Note $note)
//    {
//        //
//        return "edit";
//    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Note $note)
    {

        $validated = $request->validate([
            'title' => 'required|max:200',
            'note' => 'required|string',
        ]);

        $note->update($validated);

        return response()->json(['message' => 'Updated successfully', 'note' => $note], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy( Note $note)
    {
        $note->delete();
        return response()->json(['message'=>'Deleted successfully'],200);
    }
}
